function y=synth(freq,dur,amp,Fs,type)

%error handling
if nargin<5
  error('Five arguments required for synth()');
end

N = floor(dur*Fs);

if N == 0
  warning('Note with zero duration.');
  y = [];
  return;

elseif N < 0
  warning('Note with negative duration. Skipping.');
  y = [];
  return;
end

n = 0 : N-1;
if (strcmp(type,'guitar'))
    xx = zeros(length(freq));
    for i = 1:length(freq)
       gnote = guitar(freq(i), 1, Fs);
       xx = [xx, gnote];
    end
    y = xx;

elseif (strcmp(type,'clarinet'))

  Aenv = woodwenv(0.2, 1, 0.1, 8000);  % Example A(t) envelope
  Ienv = woodwenv(0.2, 1, 0.1, 8000);  % Example I(t) envelope

  y = clarinet(freq, Aenv, Ienv, dur, Fs);

elseif (strcmp(type,'adsr'))
    tt = 0:(1/Fs):dur;

    yy = real( 1i*exp(1j*2*pi*freq*tt));

    A = linspace(0, 1.5, (length(yy)*0.35)); %0.10
    D = linspace(1.5, 1, (length(yy)*0.05)); %0.05
    S = linspace(1, 0.6, (length(yy)*0.40)); %0.70
    R = linspace(0.6, 0, (length(yy)*0.20)); %0.15

    ADSR = [A D S R]; % Concatenate the sections of the ADSR profile

    x = zeros(size(yy));
    x(1:length(ADSR)) = ADSR;

    y = yy.*x;

elseif (strcmp(type,'trombone'))
  t = 0:(1/Fs):dur;
  envel = interp1([0 dur/6 dur/3 dur/5 dur], [0 1 .75 .6 0], 0:(1/Fs):dur);
  I_env = 5.*envel;
  y = envel.*sin(2.*pi.*freq.*t + I_env.*sin(2.*pi.*freq.*t));

 elseif (strcmp(type,'sine'))
  y = amp.*sin(2*pi*n*freq/Fs);

 elseif (strcmp(type,'echo'))
     xx = amp.*sin(2*pi*n*freq/Fs);
     y = amp.*sin(2*pi*n*freq/Fs);

     %echo filter
     delay = 0.1;
     P = round(Fs * delay);
     r = 0.9;
     
     for n=(P+1):length(xx)
         y(n) = xx(n) + r*xx(n-P);
     end
 
 elseif (strcmp(type,'bandpass'))
     L = 50;
     w = 2*pi;
     k = 0:(L-1);
     h = 2/L * cos(w*k);
     xx = amp.*sin(2*pi*n*freq/Fs);
     y = conv(xx, h, 'same');

  elseif (strcmp(type,'null'))
     xx = amp.*sin(2*pi*n*freq/Fs);

     h1 = [1 -2*cos(125) 1];
     h2 = [1 -2*cos(80) 1];
     % Cascade the two filters using convolution
     hh = conv(h1, h2);

     y = firfilt(hh, xx);

else
  error('Unknown synthesis type');
end

% smooth edges w/ 10ms ramp
if (dur > .02)
  L = 2*fix(.01*Fs)+1;  % L odd
  ramp = bartlett(L)';  % odd length
  L = ceil(L/2);
  y(1:L) = y(1:L) .* ramp(1:L);
  y(end-L+1:end) = y(end-L+1:end) .* ramp(end-L+1:end);
end
