%    Generic fixed point converter
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

function Hd = ficonv(Hd, kind)

set(Hd, 'Arithmetic', 'fixed');

if isprop(Hd, "FilterInternals")
  set(Hd, 'FilterInternals', 'SpecifyPrecision');
end

if isprop(Hd, "ProductMode")
  set(Hd, 'ProductMode', 'SpecifyPrecision');
end

if isprop(Hd, "AccumMode")
  set(Hd, 'AccumMode', 'SpecifyPrecision');
end

set(Hd, ...
    'Signed',            true, ...
    'CoeffWordLength',   16, ...
    'CoeffAutoScale',    false, ...
    'NumFracLength',     15, ...
    'InputWordLength',   16, ...
    'InputFracLength',   15, ...
    'OutputWordLength',  16, ...
    'OutputFracLength',  15, ...
    'ProductWordLength', 32, ...
    'RoundMode',         'floor');

if isprop(Hd, "CastBeforeSum")
  set(Hd, 'CastBeforeSum', true);
end
if isprop(Hd, "DenFracLength")
  set(Hd, 'DenFracLength', 15);
end

if isprop(Hd, "ProductFracLength")
  set(Hd, 'ProductFracLength', 30);
end

if isprop(Hd, "AccumFracLength")
  set(Hd, 'AccumFracLength', 30);
end

if isprop(Hd, "NumProdFracLength")
  set(Hd, 'NumProdFracLength', 30);
end

if isprop(Hd, "DenProdFracLength")
  set(Hd, 'DenProdFracLength', 30);
end

if isprop(Hd, "NumAccumFracLength")
  set(Hd, 'NumAccumFracLength', 30);
end

if isprop(Hd, "DenAccumFracLength")
  set(Hd, 'DenAccumFracLength', 30);
end

if nargin > 1 && contains(kind, 'fast', 'IgnoreCase', true)
  set(Hd, ...
      'AccumWordLength', 32, ...
      'OverflowMode',    'Wrap');
else
  set(Hd, ...
      'AccumWordLength', 64, ...
      'OverflowMode',    'Saturate');
end

if nargin > 1 && contains(kind, 'scale', 'IgnoreCase', true)
  normalize(Hd);
else
  denormalize(Hd);
end

% [EOF]
