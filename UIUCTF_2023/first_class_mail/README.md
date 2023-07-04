# UIUCTF 2023 - First class mail writeup

This is a writeup for the "First class mail" challenge from UIUCTF 2023.

## Description

Jonah posted a picture online with random things on a table. Can you find out what zip code he is located in? Flag format should be `uiuctf{zipcode}`, ex: `uiuctf{12345}`.
Hint: I think code is cool.

## Solution

1. **Initial Analysis**: At first glance of the image Jonah posted, I noticed that they had received a letter from a local Erie Insurance Agency called 'Lanyi Insurance Agency LLC'. I tried a quick Google search of the company and found their address which included the ZIP code 15642. This was obviously incorrect and a distraction. 

2. **Metadata Check**: I checked the image for any embedded metadata, but unfortunately, no useful information was found.

3. **Barcode Identification**: I then noticed a barcode on one of the letters in the image. To try and  identify the barcode, I searched through [BarcodeFAQ](https://www.barcodefaq.com/barcode-match/), which suggested that it resembled a POSTNET barcode. Further [research](https://en.wikipedia.org/wiki/POSTNET) revealed that a POSTNET barcode is an encoding technique used by the US mail service to improve sorting efficiency and accuracy. In order to create a POSTNET barcode, the ZIP code is converted into a series of digits, with each digit encoded into a barcode representation.

4. **Decoding the Barcode**: To decode the barcode back into decimal, I cropped the barcode section of the image and uploaded to a barcode reader [Dynamsoft's Barcode Reader](https://www.dynamsoft.com/barcode-reader/barcode-types/planet/). The output of the reader was `6066111234`.

5. **Extracting the ZIP code**: According to [Wikipedia](https://en.wikipedia.org/wiki/POSTNET), the first five digits of the decoded barcode represent the ZIP code. Thus, I tried the flag `uiuctf{60661}` and it was confirmed to be the correct answer!

6. **Takeaway**: When I first saw the barcode, I actually laughed and thought to myself "Nah, there's no way the ZIP code is hidden in there." Little did I know that barcodes actually hold so much information. This challenge really opened my eyes to that fact. It makes you wonder how many people out there have unknowingly uploaded photos with a sneaky barcode lurking in the background, hinting at their potential whereabouts. It's kind of creepy when you think about it.
