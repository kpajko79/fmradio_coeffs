%    Differentiator filter formatter
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

function gendiffcoeffs(cfile, hfile, fn)
  [Hd, name, Fs, pbf] = eval(fn);

  if Hd.Numerator(1) < 0
    Hd.Numerator = Hd.Numerator * -1;
  end

  set(Hd, 'Arithmetic', 'single');
  cf = coeffs(Hd).Numerator;
  cmt = name;
  gencoeffs_f(cfile, hfile, fn, cmt, cf, Fs, pbf);
  % normalize(Hd);
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled version)";
  % gencoeffs_f(cfile, hfile, "scale_" + fn, cmt, cf, Fs, pbf);
  ficonv(Hd, "normal");
  cf = coeffs(Hd).Numerator;
  cmt = name;
  gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbf, Hd.NumFracLength);
  % ficonv(Hd, "scale");
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled version)";
  % gencoeffs_q(cfile, hfile, "scale_" + fn, cmt, cf, Fs, pbf, Hd.NumFracLength);
end

function gencoeffs_f(cfile, hfile, fn, cmt, cf, Fs, pbf)
  len = length(cf);
  sts = gendiffstats(cf, Fs, pbf);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "#define COEFFS_%s_F (const float[%d]){ ", upper(fn), len);
  for i = 1:len
    fprintf(hfile, "% .10ff, ", cf(i));
  end
  fprintf(hfile, " }\n");
  for i = 1:len
    fprintf(hfile, "#define COEFFS_%s_F_%d % .10ff\n", upper(fn), i, cf(i));
  end
  fprintf(hfile, "\n");
end

function gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbf, bits)
  len = length(cf);
  sts = gendiffstats(cf, Fs, pbf);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "#define COEFFS_%s (const pct_1q15_t[%d]){ ", upper(fn), len);
  for i = 1:len
    fprintf(hfile, "% 6d, ", cf(i) * 2^bits);
  end
  fprintf(hfile, " }\n");
  for i = 1:len
    fprintf(hfile, "#define COEFFS_%s_%d % 6d\n", upper(fn), i, cf(i) * 2^bits);
  end
  fprintf(hfile, "\n");
end
