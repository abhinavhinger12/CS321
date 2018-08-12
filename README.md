# CS321
This Repo contains Assignment Submissions for Peripherals Lab-CS321 by Group 16
* Abhinav Hinger 160101004
* Akhil Chandra 160101011
* Ansh Sood 160101012
* Shimona Verma 160101065

## 8085 Programming Model
8085 processor has 7 8-bit registers including accumulator and 6 others namely B,C,D,E,H and L.Depending upon requirements,these registers other than Accumulator(A) can be used as Independent Byte Registers or as Register Pairs.

All Addresses and Data Values are to be written in Hexadecimal system.(Eg. LDA 8200H is a instruction and loads the value from Memory location 8200H in the Main Memory to the Accumulator.

## Guidelines to Run 
1. Download the starter zip from CSE Repo > Hardware and VLSI Lab > HW Lab > esa-xt85.zip
2. Using Adminstrator access , install c16.exe.We will use this to convert our .asm file to .lst and .hex.For additional steps, follow the Help guide from the attached repo.
3. To run the .HEX file on the microprocessor , start the CMD prompt in Admin mode and run xt85.exe.
4. Before Downloading the file on the board , turn the 1st DIP switch ON (By default) and 4th DIP switch ON to enable the download mode of the 8085 processor.Press RESET to execute the changes.
5. Press Ctrl+D twice to get a Pop-up to enter the File name.Press Enter until the file is completely downloaded.
6. Turn the Download DIP off and press RESET .
7. The file is now downloaded to the board . Follow the steps from the Help Guide to run the program.

## Assignments
### 1. 8-bit and 16-bit Calculator
This program takes 2 Hexadecimal numbers(8bit or 16bit) and another integer to specify the instruction(+,-,\*,/). It then calculates the result and stores it in consecutive memory addresses.
1. __Addition__(A+B):
  * For 8-bit ,ADD B instruction is used.It adds the contents of B to the Accumulator A and stores the result in A itself.It
  also sets the Carry Flag 1 if there is carry which is displayed in next address.
  * For 16-bit we used register pair H,L analogous to Accumulator and DAD (Adds Register pair to H,L pair) and sets Carry
  Flag if carry.
2. __Subtraction__(A-B):
  * For 8-bit ,SUB instruction is used.It subtracts the contents of register specified from the Accumulator A and stores the
  result in A itself.It also sets the Borrow Flag 1 if there is a borrow.
  * For 16-bit ,since the operation is only performed on 8 bits , we subtracted LSB and MSB of the numbers separately
  First LSBs are operated , the borrow generated from this operation is subtracted from MSB of A.MSB of B is then subtracted
  from the result.The Borrow bit from this operation is stored in consecutive Memory locations.
  * For 8 bit and 16 bit Subtractor,if the result is negative then the 2's complement of the result is displayed by the
  processor. We converted it back along with the borrow bit(Indicates negative result).
Eg 123H - 1234H --> 0001H 1111H (Answer is -1111)
3. __Multiplication__(A\*B):
  * We are doing repetitive addition of A , B times.Carry is incremented at every addition if it set carry flag 1.
  * As the multiplcation of two 8 bit numbers can be maximum of 16 bits so we need register pair to store the result.
  * Same Algorithm is followed for 16 bit numbers.Similar operations for Register Pairs are used (INX,DCX,ORA etc.)
4. __Division__ (A\/B):
  * We are doing repeated subtraction of B from until A is less than B.The further subtraction will lead to a borrow bit 
   the loop breaks.The number of subtractions done until just before A was negative is the quotient.The closest positive
   value of A is the Remainder(Calculated by adding B to 1st negative value of A).

### 2. 24 Hour Clock and Timer
