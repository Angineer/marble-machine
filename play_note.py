# Simple demo of of the PCA9685 PWM servo/LED controller library.
# This will move channel 0 from min to max position repeatedly.
# Author: Tony DiCola
# License: Public Domain
from __future__ import division
import time
import sys

# Import the PCA9685 module.
import Adafruit_PCA9685

# Uncomment to enable debug output.
#import logging
#logging.basicConfig(level=logging.DEBUG)

# Initialise the PCA9685 using the default address (0x40).
pwm = Adafruit_PCA9685.PCA9685()

# Alternatively specify a different address and/or bus:
#pwm = Adafruit_PCA9685.PCA9685(address=0x41, busnum=2)

# Configure min and max servo pulse lengths
#servo_min = 170  # Min pulse length out of 4096
#servo_max = 640  # Max pulse length out of 4096
servo_min = 200  # Min pulse length out of 4096
servo_max = 350  # Max pulse length out of 4096

# Set frequency to 60hz, good for servos.
pwm.set_pwm_freq(60)

def set_servo_array(bit_mask):
    ''' Set all servos to on/off positions,
        specified by bits in the bitmask
        that gets passed in
        '''
    for i in range(16):
      if (bit_mask >> i) & 0x1:
        pwm.set_pwm(i, 0, servo_max)
      else:
        pwm.set_pwm(i, 0, servo_min)
'''
def main():
    if len(sys.argv) == 1:
        print("Please include a song file argument")
        sys.exit()

    with open(sys.argv[1], 'r') as fp:
        contents = fp.readlines()
        for line in contents:
            note = line.split(',')

            mask = int(note[0], 0) # Need 0 base to convert from hex
            sleep_time = float(note[1])

            set_servo_array(mask)
            time.sleep(sleep_time)

if __name__ == '__main__':
    main()

'''
set_servo_array(int(sys.argv[1],0)) # 0 makes it an integer
time.sleep(float(sys.argv[2]))
set_servo_array(int(0x0000))
