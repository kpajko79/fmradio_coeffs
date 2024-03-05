%    FIR filter formatter
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

function genfircoeffs(cfile, hfile, fn)
  [Hd, name, Fs, pbfs, sbfs] = eval(fn);

  if isreal(Hd.Numerator)
    ffunc = @gencoeffs_f;
    qfunc = @gencoeffs_q;
  else
    ffunc = @gencoeffs_c;
    qfunc = @gencoeffs_Q;
  end

  set(Hd, 'Arithmetic', 'single');
  cf = coeffs(Hd).Numerator;
  cmt = name;
  ffunc(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs);
  % normalize(Hd);
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled version)";
  % ffunc(cfile, hfile, "scale_" + fn, cmt, cf, Fs, pbfs, sbfs);
  ficonv(Hd, "normal");
  cf = coeffs(Hd).Numerator;
  cmt = name;
  qfunc(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
  % ficonv(Hd, "fast");
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(fast version)";
  % qfunc(cfile, hfile, "fast_" + fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
  % ficonv(Hd, "scale");
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled version)";
  % qfunc(cfile, hfile, "scale_" + fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
  % ficonv(Hd, "scale_fast");
  % cf = coeffs(Hd).Numerator;
  % cmt = name + "\n(scaled fast version)";
  % qfunc(cfile, hfile, "scale_fast_" + fn, cmt, cf, Fs, pbfs, sbfs, Hd.NumFracLength);
end

function gencoeffs_f(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs)
  len = length(cf);
  sts = genfilterstats(cf, 1, Fs, pbfs, sbfs);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "extern float %s_f[%d];\n\n", fn, len);
  fprintf(cfile, "float %s_f[%d] = {\n\t", fn, len);
  for i = 1:len
    fprintf(cfile, "% .10ff, ", cf(i));
    if ((mod(i, 4) == 0) && (i ~= len))
      fprintf(cfile, "\n\t");
    end
  end
  fprintf(cfile, "\n};\n\n");
end

function gencoeffs_q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, bits)
  len = length(cf);
  sts = genfilterstats(cf, 1, Fs, pbfs, sbfs);
  cf = cf .* 2^bits;
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "extern pct_1q15_t %s[%d];\n\n", fn, len);
  fprintf(cfile, "pct_1q15_t %s[%d] = {\n\t", fn, len);
  for i = 1:len
    fprintf(cfile, "% 6d, ", cf(i));
    if ((mod(i, 8) == 0) && (i ~= len))
      fprintf(cfile, "\n\t");
    end
  end
  fprintf(cfile, "\n};\n\n");
end

function gencoeffs_c(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs)
  len = length(cf);
  sts = genfilterstats(cf, 1, Fs, pbfs, sbfs);
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "extern float complex %s_c[%d];\n\n", fn, len);
  fprintf(cfile, "float complex %s_c[%d] = {\n\t", fn, len);
  for i = 1:len
    re = real(cf(i));
    im = imag(cf(i));
    if (im < 0)
      ims = "-";
    else
      ims = "+";
    end
    fprintf(cfile, "% .10ff %s %.10ffi, ", re, ims, abs(im));
    if ((mod(i, 2) == 0) && (i ~= len))
      fprintf(cfile, "\n\t");
    end
  end
  fprintf(cfile, "\n};\n\n");
end

function gencoeffs_Q(cfile, hfile, fn, cmt, cf, Fs, pbfs, sbfs, bits)
  len = length(cf);
  sts = genfilterstats(cf, 1, Fs, pbfs, sbfs);
  re = real(cf) .* 2^bits;
  im = imag(cf) .* 2^bits;
  fprintf(hfile, gencomment(cmt + "\n\n" + sts));
  fprintf(hfile, "extern pct_1q15_t %s_real[%d];\n", fn, len);
  fprintf(cfile, "pct_1q15_t %s_real[%d] = {\n\t", fn, len);
  for i = 1:len
    fprintf(cfile, "% 6d, ", re(i));
    if ((mod(i, 8) == 0) && (i ~= len))
      fprintf(cfile, "\n\t");
    end
  end
  fprintf(cfile, "\n};\n\n");
  fprintf(hfile, "extern pct_1q15_t %s_imag[%d];\n\n", fn, len);
  fprintf(cfile, "pct_1q15_t %s_imag[%d] = {\n\t", fn, len);
  for i = 1:len
    fprintf(cfile, "% 6d, ", im(i));
    if ((mod(i, 8) == 0) && (i ~= len))
      fprintf(cfile, "\n\t");
    end
  end
  fprintf(cfile, "\n};\n\n");
end
