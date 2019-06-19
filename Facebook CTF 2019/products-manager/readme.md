## task name
products manager

## task description
Come play with our products manager application!

http://challenges.fbctf.com:8087

Written by Vampire

(This problem does not require any brute force or scanning. We will ban your team if we detect brute force or scanning).

save file(s) of the task in the same folder

## solution

For this challenge you are given a link to the product management website where you can view and add products. The challenge also gives you access to the PHP source code files of the product manager site.

![imgSource](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_source.jpg)



The product manager website is simple. To add a product, just input the name, description, and a secret key; however, you cannot add the same product twice. To view the product, enter the name and the secret key.

![imgAdd](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_view.jpg)



At the outset, five Facebook products (including Facebook itself) are already in the product list. To view them, you need to know the secret key. 

![imgTop5](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_top5.jpg)



So how or where do you get the secret key?

After trying out a number of different input permutations without success, the PHP source code came to my rescue. 

Analyzing the add.php, view.php, and db.php source codes, you will find that the product name input validation is rudimentary - it just checks if the name already exists. 

![imgAdd](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_add_php_check.jpg)

![imgGetProduct](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_db_php_getproduct.jpg)

So when you put a space at the end of the product name, even if the name already exists, it is valid, overwriting the data stored in the database! Moreover, the db.php source code gives you a clue as to which of the top five FB products has the flag. It turns out, the flag is in the Facebook product description!

![imgClue](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_db_php_clue.jpg)

![imgFlag](https://raw.githubusercontent.com/mcdxn/writeups/master/Facebook%20CTF%202019/products-manager/img_flag.jpg)


mcdxn
