%    Lowpass filter generator for audio decimator
%    Copyright (C) 2024  Patrik Kluba <kpajko79@gmail.com>
%
%    Permission is hereby granted, free of charge, to any person obtaining a copy
%    of this software and associated documentation files (the "Software"), to deal
%    in the Software without restriction, including without limitation the rights
%    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%    copies of the Software, and to permit persons to whom the Software is
%    furnished to do so, subject to the following conditions:
%
%    The above copyright notice and this permission notice shall be included in all
%    copies or substantial portions of the Software.
%
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%    SOFTWARE.
%
%    SPDX-License-Identifier: MIT

function [Hd, name, Fs, pbfs, sbfs] = quickaudiohalvernords_243K75

Fs    = 243750;

N     = 36;
Fpass = 53000;
Fstop = 68875;
Rippl = 0.005;
CEMs  = {'c', 'w'};
dens  = 20;

Dpass = Rippl/20;
b  = fircband(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Dpass 1], ...
              CEMs, {dens});
Hd = dfilt.dffir(b);

name = sprintf("Quick antialias filter for %.3f Ksps baseband halving", Fs/1000);
pbfs = [0 Fpass];
sbfs = [Fstop Fs/2];

% [EOF]
