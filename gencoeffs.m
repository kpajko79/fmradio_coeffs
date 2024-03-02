%    Filter coefficients generator driver
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

function gencoeffs
  hwcoeffs = [ "hwfilter_406K25" ];

  diffcoeffs = [ "differentiator_288K", "differentiator6_288K", "differentiator8_288K", ...
                 "differentiatornords_288K", "differentiatornords6_288K", "differentiatornords8_288K", ...
                 "differentiator_243K75", "differentiator6_243K75", "differentiator8_243K75", ...
                 "differentiatornords_243K75", "differentiatornords6_243K75", "differentiatornords8_243K75" ];

  fircoeffs = [ "quickaudiohalver_288K", "audiohalver_288K", ...
                "audiolowpass_144K", "pilot_144K", "pilot2_144K", ...
                "rdsdecimate_144K", "rdsresample_24K", "killrds_144K", ...
                "rdsrrcprototype_19K", ...
                "quickaudiohalvernords_243K75", "audiohalvernords_243K75", ...
                "audiolowpass_121K875", "pilot_121K875", "pilot2_121K875", ...
                "killrds_121K875" ];

  iircoeffs = [ "deemph_eu_48K", "deemph_us_48K", ...
                "deemph_eu_40K625", "deemph_us_40K625" ];

  lic = erase(fileread("LICENSE"), char(13));
  lic = strrep(lic, char(10), "\n");
  cmt = gencomment(lic) + "\n";

  cfile = fopen("coeffs.c", 'w', 'n', "US-ASCII");
  hfile = fopen("coeffs.h", 'w', 'n', "US-ASCII");

  fprintf(hfile, cmt);
  fprintf(hfile, "#ifndef COEFFS__H\n");
  fprintf(hfile, "#define COEFFS__H\n\n");
  fprintf(hfile, "#include <pct_complex.h>\n\n");

  fprintf(cfile, cmt);
  fprintf(cfile, "#include <coeffs.h>\n\n");

  for coeff = 1:length(hwcoeffs)
    genhwcoeffs(cfile, hfile, hwcoeffs(coeff));
  end

  for coeff = 1:length(diffcoeffs)
    gendiffcoeffs(cfile, hfile, diffcoeffs(coeff));
  end

  for coeff = 1:length(fircoeffs)
    genfircoeffs(cfile, hfile, fircoeffs(coeff));
  end

  for coeff = 1:length(iircoeffs)
    geniircoeffs(cfile, hfile, iircoeffs(coeff));
  end

  fprintf(hfile, "#endif\n");

  fclose(cfile);
  fclose(hfile);
end
