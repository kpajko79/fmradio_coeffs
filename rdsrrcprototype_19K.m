%    RRC filter prototype generator for RDS
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

function [Hd, name, Fs, pbfs, sbfs] = rdsrrcprototype_19K

span = 18.75;
Fs = 19000;
Fc = 1187.5;
Beta = 0.5;

ovr = Fs/Fc/2;
N = span*ovr;

shape = [ 1, 0, 0, 0, 0, 0, 0, 0, -1 ];

% b = rcosdesign(1, span, ovr, 'sqrt');
win = kaiser(N+1, Beta);
b = firrcos(N, Fc, 1, Fs, 'rolloff', 'sqrt', [], win);
m = conv(b, shape, 'same');
m = m / 1.539517215148026308;

Hd = dfilt.dffir(m);

name = sprintf("%dx oversampling RRC filter for RDS", Fs/(Fc*2));
pbfs = [0 Fc*2];
sbfs = [Fc*2 Fs/2];

% [EOF]
