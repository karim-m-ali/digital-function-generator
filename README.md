
# Generic Function Generator

This is a basic function generator written for FPGAs. It implements 
standard waveforms: sine, square, triangle, and sawtooth. It does not 
control amplitude and requires an external DAC circuit to be used.
Frequency can be controlled by a division factor of the external clock.

## Parameters
### Inputs
1. Clock: 
    The clock signal driving the function generator.

2. Reset: 
    Signal for resetting the function generator.

3. Waveform: 
    Selection signal for choosing the type of waveform (sine, square, 
    triangle, sawtooth).

4. Frequency (or division factor): 
    Input for controlling the frequency of the generated waveform. This 
    can be implemented as a division factor of the external clock.

5. Duty cycle: 
    Input for controlling the duty cycle of square waves.

6. Phase offset: 
    Input for adjusting the phase offset of the waveform, useful for 
    synchronization.

### Outputs
1. Digital data signal: 
    The generated waveform data, typically of a generic length, which 
    can be output to external components or further processing stages.
