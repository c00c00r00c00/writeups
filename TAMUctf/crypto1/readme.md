
## The task:
Crypto#1 “-.-”
To 1337-H4X0R:
 Our coworker Bob loves a good classical cipher. Unfortunately, he also loves to send everything encrypted with these ciphers. Can you go ahead and decrypt this for me? 

The file with the file is attached. 

## solution
1. Let's notice there are several repeated elements, such as "dah -dit di"
2. After googling we can find there is Morse Code. Each Latin letter is encode by combination of "dah -dit di" (example: for "A" -- "di-dah" and so on).
3. After decoding it (manually or using some software) there is the follow message: "0X57702A6C5874475138653871696D4D59552A737646486B6A49742A5251264A705A766A6D2125254B446B667023594939666B346455346C423372546F5430505A516D4351454B5942345A4D762A21466B386C25626A716C504D6649476D612525467A4720676967656D7B433169634B5F636C31434B2D7930755F683476335F6D3449317D20757634767A4B5A7434796F6D694453684C6D38514546695574774A4049754F596658263875404769213125547176305663527A56216A217675757038426A644949714535772324255634555A4F595A327A37543235743726784C40574F373431305149" (there is the full message).
4. We can notice that prefix "0x" in the beginning means Hexadecimal number representation.
5. If so, we can decode the rest part, using "https://gchq.github.io/CyberChef/" service, for example. 
6. We will got the (full) message: "Wp*lXtGQ8e8qimMYU*svFHkjIt*RQ&JpZvjm!%%KDkfp#YI9fk4dU4lB3rToT0PZQmCQEKYB4ZMv*!Fk8l%bjqlPMfIGma%%FzGgigem{C1icK_cl1CK-y0u_h4v3_m4I1} uv4vzKZt4yomiDShLm8QEFiUtwJ@IuOYfX&8u@Gi!1%Tqv0VcRzV!j!vuup8BjdIIqE5w#$%V4UZOYZ2z7T25t7&xL@WO7410QI".
7. And we can find the flag: gigem{C1icK_cl1CK-y0u_h4v3_m4I1}
8. Profit!

P.S. Please see the attached presentation file "crypto1_julia.pdf" for more detailes.
