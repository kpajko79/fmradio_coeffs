%    FM deemphasis filter generator (US)
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

function [Hd, name, Fs, pbfs, sbfs] = deemph_us_48K

Fs = 48000;

N   = 1;
tau = 75e-6;

Fc = 1/(2*pi*tau);
h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
Hd = design(h, 'butter', 'FilterStructure', 'df1sos');

[b, a] = tf(Hd);
Hd = dfilt.df1(b, a);

name = sprintf("FM de-emphasis filter for %.3f Ksps (US)", Fs/1000);
pbfs = [0 Fs/2];
sbfs = [];

% [EOF]
