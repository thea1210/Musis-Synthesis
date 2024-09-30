midi = readmidi('onegai.mid');
[sine,Fs0] = midi2audio(midi,'sine');
[adsr,Fs] = midi2audio(midi,'adsr');
[clarinet,Fs1] = midi2audio(midi,'clarinet'); 
[echo,Fs2] = midi2audio(midi,'echo'); 
[trombone,Fs4] = midi2audio(midi,'trombone'); 
[null,Fs5] = midi2audio(midi,'null'); 
[bp,Fs6] = midi2audio(midi,'bandpass'); 

track0 = sine(1:882000);
track1 = adsr(882001:1764000);
track2 = clarinet(1764001:2954700);
track3 = trombone(2954701:3528000);
track4 = bp(3528001:4806900);
track5 = null(4806901:5733000);
track6 = echo(5733001:7011900);

song = [track0, track1, track2, track3, track4, track5, track6];

soundsc(song, Fs);
