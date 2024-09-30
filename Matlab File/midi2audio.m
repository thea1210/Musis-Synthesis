function [y,Fs]=midi2audio(input,synthtype, Fs)

if (nargin<2)
  synthtype='fm';
end
if (nargin<3)
  Fs=44.1e3; 
end

endtime = -1;
if (isstruct(input))
  [Notes,endtime] = midiInfo(input,0);
elseif (ischar(input))
  [Notes,endtime] = midiInfo(readmidi(input), 0);
else
  Notes = input;
end

% t2 = 6th col
if (endtime == -1)
  endtime = max(Notes(:,6));
end
if (length(endtime)>1)
  endtime = max(endtime);
end


y = zeros(1,ceil(endtime*Fs));

for i=1:size(Notes,1)

  f = getFreq(Notes(i,3));
  dur = Notes(i,6) - Notes(i,5);
  amp = Notes(i,4)/127;

  yt = synth(f, dur, amp, Fs, synthtype);
  if(strcmp(synthtype,'guitar'))
    y = yt;
  else
  n1 = floor(Notes(i,5)*Fs)+1;
  N = length(yt);  

  n2 = n1 + N - 1;
  y(n1:n2) = y(n1:n2) + reshape(yt,1,[]);
  end

end
