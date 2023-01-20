
# Sonar-Digital-Communication-Matched-Filters

project explores the concept of binary codes, sonar communication and matched filter systems.

## Part 1: Sonar Systems

Active Sonar is an implementation that transmits sound waves to an object and receives reflected
waves from it, which are used to detect an object and determine the distance from object A to
object B. Similarly, to find the distance from the submarine to the friendly ship, both the echo
and ping signals were convoluted. By using a matched filter on the echo signal, the maximum
value was determined to be the highest point of the Convoluted Signal graph, 109 samples per
second. Since both signals are sampled at 100 samples per second, the maximum value was
divided by 100 and then divided by two (transmitter sound and reflected sound). Finally, 0.545
was multiplied by the speed of sound (5000 ft per second) resulting in a distance of 2,725 ft.

![Part1](https://user-images.githubusercontent.com/32372013/213818771-efba3c5c-36e3-4491-8aab-a5948c9dbfc8.png)


## Part 2: Digital Message Reception

The purpose of this part is to use a matched filter to read a binary message from a friendly ship
and decode it using the ascii.code file. The code needs to be able to read any received signal, all
of which are sampled at 100 samples per second.
The function needs to have three arguments to decode the message. The first argument is the
received signal, the second argument is for the sample rate, and the last argument is an optional
argument for the pulse.  

The first thing we needed to think about was the amount of arguments for the function. The user
needs to input a received signal and a sample rate, but if the user does not input the pulse signal
for the third argument, the function should default to a square wave of duration 0.3 seconds. The
options given to the user for the third argument are ‘triangle’, ‘sine’, ‘impulse’, ‘square’ or
nothing. Entering a pulse name convolves the signal with the corresponding pulse. We stick to
using the triangle pulse to correctly decode the signal.  

The next step was to perform the convolution. We used the received signal as the first argument
of the conv function and flipped the pulse using fliplr() to remove the noise from the signal.  

To store the bits from the signal properly, we used an array of zeros with length equal to the total
number of bits in the signal. We found the total number of bits by dividing the length of the
received signal by the length of the pulse signal. To find out where the ones were located in the
signal, we checked the index in the convolution array by incrementing by the length of the pulse
signal. A for loop was used to check the convolution by the length of the pulse signal, and for
every time the convolution was high (greater than zero), we would change the zero in that index
to a one to represent the positive pulse signal.  

After arranging the ones and zeros in the array, we need to separate the bits into bytes so that we
can decipher the message. We did this by creating another zeros array for the bytes. The
difference between the byte array and the bit array is that each index within the byte array will
have 8 bits within it since 8 bits equals 1 byte. Two for loops were used for this process. The
outer for loop was iterating through each of the bytes while the inner for loop was going through
each index to sum up the bits. The sum of the bits in the inner for loop is done by multiplying by
10 raised to the power of 7 and then it continuously loops until the exponent reaches 0, resulting
in a 8 bit long index.  

Once the byte array was created, we were able to start decoding the message. To do this, we have
to read the ascii code document by using textscan(). We used a for loop to iterate through the
byte array and decode the message. The find function was used to find the corresponding byte
equivalent in the ascii code and outputted into msg to decode the message.  

**Received Signals Decoded:**  

New_ReceivedSignal1 = ‘SOS’  
New_ReceivedSignal2 = ‘Help!’  
New_ReceivedSignal3 = ‘Nevermind’

## Part 3: Digital Message Transmission  
The purpose of this part is to encode a message to send back to the friendly ship. The code
chosen to be translated is “covid-19”. We write the phrase as a string at the beginning of the
script.  

The process of encoding this message is somewhat similar to how we decode the signal in the
previous part but just in reverse. We start off by establishing the number of arguments due to the
pulse argument being the optional argument. The major difference between this part and the
previous part is that only two arguments would be necessary for the sample rate and pulse
because we are creating our own signal rather than decoding a received signal.  

The next step would be to read the ascii.code file using textscan to help us encode our message.
We encoded the message by establishing the total number of bytes and bits for our word and then
creating a zeros array. We store the ascii values form the message as a string of bits using nested
for loops.  

We made another nested for loop to store our signal in negative and positive pulses. The for loop
goes through each bit and determines if each bit is a zero or one and concatenates the pulses
together into another array called original.  

We then add noise to our signal by using the randn() function and add it to our original signal
that we have created. It is important that the arrays for the noise and original signal are the same
so that we can add them together.  

We then graph both the original signal and the noisy version of the signal and use the decode
function we created to make sure the code works properly.  

![image](https://user-images.githubusercontent.com/32372013/213820293-ab9b3bf6-171b-463f-9890-d0674a4b393f.png)
![image](https://user-images.githubusercontent.com/32372013/213820433-e8a00ffb-5b7e-473f-ab4b-8380dd1c4aa7.png)  

**Output:**  
![image](https://user-images.githubusercontent.com/32372013/213820624-c055985f-d4f2-4fa0-830d-986960b6bc7c.png)  

We now need to find out which of the pulses works best to decode messages. We do this by gradually increasing the noise and adding it to the original signal. We run a for loop that creates a signal containing the original message and we add a randomly generated noise multiplied by a scalar. This scalar increases with each iteration in the for loop. The message is then decoded
using our previous decode script and stored to compare to see how well the pulse decoded the signal. We run fifty iterations for each pulse, the results are shown below.

![image](https://user-images.githubusercontent.com/32372013/213820957-19e28838-48dd-4d04-8d27-9f1dfc272805.png)  

![image](https://user-images.githubusercontent.com/32372013/213821004-23d5b201-cd73-45af-ac2c-c29d952d46e0.png)  

ased on the results above, it seems as though the square pulse is most robust because it is able to decode the message at higher levels of noise compared to the other pulses.
The final outputs of the function are the graphs for the original signal and the noisy version of the signal, the message decoded, and the many iterations of decoding the message with a scaled noisy signal (depending on which pulse signal was chosen). We kept the x-axis as number of samples to make things easier to decipher, but we could easily get the number of seconds by dividing by the sample rate.





