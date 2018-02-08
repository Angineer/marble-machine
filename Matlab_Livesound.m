%Frequency of notes 
E4 = 329.63; 
D4s = 311.13;
D4 = 293.66;
C4s = 277.18;
C4 = 261.63;
B3 = 246.94;
A3s = 233.08;
A3 = 220.00;    
G3s = 207.65;
G3 = 196.00;
F3s = 185.00;
F3 = 174.61;
E3 = 164.81;
D3s = 155.56;
D3 = 146.83;
C3s = 138.59;
C3 = 130.81;
Notes = [C3 C3s D3 D3s E3 F3 F3s G3 G3s A3 A3s B3 C4 C4s D4 D4s E4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time =0; % Length of song in specified range
time_step = 0.5;
s=[];
recobj = audiorecorder(44100,16,1);
ssh_text = 'ssh pi@128.2.58.189 python /home/pi/Documents/Marbles/play_note.py ';
tic
% while time==0
while true
recordblocking(recobj,time_step);
% play(recobj)
y = getaudiodata(recobj);
s = [s y];
% plot(y)
Fn = 44100/2;
L = length(y); % Length Of Signal in specified range
fty = fft(y)/L;% Normalised Fourier Transform
Fv = linspace(0, 1, fix(L/2)+1)*Fn; % Frequency Vector
% Iv = 1:length(Fv); % Index Vector

R = find(Fv<1000); %used to plot frequenciees under 1000Hz
rang = length(R);

Iv = 1:rang; % Index Vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

% subplot(2,1,1);

%Plots frequency and find peaks
% minPH = 1e-3; %Minimum peak height
% minPD = 0; %minimum peak distance

% [pks,locs] = findpeaks(abs(fty(Iv))*2,'MinPeakHeight',minPH,'MinPeakDistance',minPD); 
% plot(Fv(1:rang), abs(fty(Iv))*2,Fv(locs),pks,'ok')
yplot = abs(fty(Iv))*2;
xplot = Fv(1:rang);
% 
plot(xplot, yplot) % data plot
hold on;
title(sprintf('Time %2.2fs',time))
xlabel ('Frequency [Hz]')
ylabel ('Intensity [-]')
% % XData=get(get(gca,'children'),'XData');
% % YData=get(get(gca,'children'),'YData'); 
% xlim([100 350]);
% % hold on
% % % NotePlot;
% % hold off
% % disp(['Peaks: ' num2str(Fv(locs))]) % displays peak frequencies
% edges = [ave(123.47,C3) ave(C3,C3s) ave(C3s,D3) ave(D3,D3s) ave(D3s, E3)...
%     ave(E3, F3) ave(F3,F3s) ave(F3s,G3) ave(G3, G3s) ave(G3s,A3)...
%     ave(A3,A3s) ave(A3s,B3) ave(B3,C4) ave(C4,C4s) ave(C4s,D4) ...
%     ave(D4,311.13) ave(311.13,E4) ave(E4, 349.23) ];

%Plots position of notes
% hold on
% h=histogram(Fv(1:rang),edges)
% % h=histogram(Fv(1:rang),edges)
% h=histogram(Fv(1:rang))
% ylinemax = 5.7e-3;
% ytxtmax = 5.7e-3;
% y1 = [0 ylinemax];
% c4 = [C4 C4];
% d4 = [D4 D4];
% e4 = [E4 E4];
% f4 = [F3*2 F3*2];
% b3 = [B3 B3];
% g3 = [G3 G3];
% a3 = [A3 A3];
% text(C4,ytxtmax,'C4','HorizontalAlignment','center')
% text(D4,ytxtmax,'D4','HorizontalAlignment','center')
% text(E4,ytxtmax,'E4','HorizontalAlignment','center')
% text(F3*2,ytxtmax,'F3','HorizontalAlignment','center')
% text(B3,ytxtmax,'B3','HorizontalAlignment','center')
% text(G3,ytxtmax,'G3','HorizontalAlignment','center')
% text(A3,ytxtmax,'A3','HorizontalAlignment','center')
% 
% plot(c4,y1,'--r')
% plot(d4,y1,'--r')
% plot(e4,y1,'--r')
% plot(f4,y1,'--r')
% plot(b3,y1,'--r')
% plot(g3,y1,'--r')
% plot(a3,y1,'--r')

%Plots Cutoff for peak finding
% plot([0 1000],[minPH minPH],'--b') %Horizontal line showing peak cutoff
% hold off
% grid
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% NoteSelect = [];
% length(yplot)

%Bin rescaling
a=1;
for i = 1:length(xplot)
    if xplot(i) > edges(a)
        b(a) = i;
        
        if a<length(edges)
            a = a+1;
        end
        if xplot(i) > edges(length(edges))
        break
        end
    end
end
c=zeros(length(edges)-1);
i = 0;
for a = 2:length(b)
    i = i+1;
%     c(i) = max(yplot((b(a-1)):(b(a))));
    c(i) = max(yplot((b(a-1)):(b(a)-1)));
end


% %Plots time domain
% subplot(2,1,2);
% plot(Notes, c,'or'); hold off
% hold on
% % h=histogram(Fv(1:rang),edges)
% % figure;
% % xtime = linspace(low,high,length(y(44100*low:44100*high)));
% % plot(xtime, y(44100*low:44100*high))
% % xlabel('time (s)')
% grid;
% NotePlot;
% hold off

cbin = ones(1,length(c));
cbin(c<(max(c)*0.75))=0;
plot(Notes, c,'or'); hold off
%cbin
%B =binaryVectorToHex(cbin)
notes_to_play = dec2hex(bin2dec(num2str(cbin)))
system([ssh_text,'0x', notes_to_play, ' ',num2str(time_step)]);
time = time +time_step;
end
% toc