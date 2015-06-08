%Credit to: Luqman Nuradi Prawadika (https://www.facebook.com/luqman.prawadika)
clc;
clear all;
disp('Batas: Antara 0 - 7200')
Agreen = input('Tentukan lama lampu hijau 1 (detik): ');
Bgreen = input('Tentukan lama lampu hijau 2 (detik): ');
Cgreen = input('Tentukan lama lampu hijau 3 (detik): ');
cyclelength = Agreen + Bgreen + Cgreen;

if (Agreen <= 0 | Bgreen <= 0 | Cgreen <= 0 | Agreen >= 7200 | Bgreen >= 7200 | Cgreen >= 7200)
    
    disp('Maaf, inputan Anda tidak dapat disimulasikan')
    
else

Ajamtime = [0,0,0,0];
Bjamtime = [0,0,0,0];
Cjamtime = [0,0,0,0];
Djamtime = [0,0,0,0];
Amultistop = [0,0,0,0];
Bmultistop = [0,0,0,0];
Cmultistop = [0,0,0,0];
datamatrix = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
              117.2246504,70.4987408,167.6394476,31.9703592,117.2246504,70.4987408,167.6394476,31.9703592,94.271572,19.469129,116.814774,24.592584,45.9061568,34.4296176,82.3851564,28.2814716;
              98.370336,24.592584,88.123426,31.1506064,91.4024372,50.8246736,111.8962572,54.5135612,70.9086172,32.790112,96.320954,35.6592468,69.678988,29.1012244,91.4024372,39.3481344;
              94.6814484,38.5283816,88.123426,57.382696,84.024662,35.2493704,94.6814484,71.3184936,96.7308304,32.3802356,102.8789764,51.23455,101.2394708,27.8715952,87.7135496,42.2172692;
              89.7629316,31.5604828,86.074044,68.0394824,79.925898,28.2814716,89.3530552,39.3481344,77.0567632,31.1506064,77.876516,52.8740556,104.1086056,20.49382,83.6147856,53.6938084;
              76.2370104,34.4296176,81.5654036,49.185168,79.925898,22.1333256,82.3851564,41.8073928,84.8444148,11.4765392,73.3678756,42.2172692,88.123426,25.4123368,91.4024372,50.4147972;
              143.45674,55.333314,168.049324,75.2123194,81.97528,53.283932,94.271572,43.037022,95.9110776,31.5604828,89.7629316,38.5283816,96.7308304,24.592584,82.3851564,40.98764;
              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]/60;
hourseries = [0,2,4,7,10,12,14,18]/18;
frihourseries = [0,2,4,6.5,10,12,14,18]/18;
for day = 1:4
    t = 0;
    green = 1;
    Avol = 0;
    Bvol = 0;
    Cvol = 0;
    Dvol = 0;
    CDvol = 0;
    Agreenrem = 0;
    Bgreenrem = 0;
    Cgreenrem = 0;
    if (day == 2)
        timeseries = frihourseries;
    else
        timeseries = hourseries;
    end;
    
    for interval = 1:7
        Aratecoefs = polyfit([timeseries(interval),timeseries(interval+1)],[datamatrix(interval,4*day - 3),datamatrix(interval + 1,4*day - 3)],1);
        Arateinfunction = @(x)Aratecoefs(1)*x+Aratecoefs(2);
        Bratecoefs = polyfit([timeseries(interval),timeseries(interval+1)],[datamatrix(interval,4*day - 2),datamatrix(interval + 1,4*day - 2)],1);
        Brateinfunction = @(x)Aratecoefs(1)*x+Aratecoefs(2);
        Cratecoefs = polyfit([timeseries(interval),timeseries(interval+1)],[datamatrix(interval,4*day - 1),datamatrix(interval + 1,4*day - 1)],1);
        Crateinfunction = @(x)Aratecoefs(1)*x+Aratecoefs(2);
        Dratecoefs = polyfit([timeseries(interval),timeseries(interval+1)],[datamatrix(interval,4*day),datamatrix(interval + 1,4*day)],1);
        Drateinfunction = @(x)Aratecoefs(1)*x+Aratecoefs(2);
        intervaltime = (timeseries(interval + 1) - timeseries(interval))*3600*18;
        while (intervaltime > 0)
            if (green == 1)
                if (Agreenrem > 0)
                    time = Agreenrem;
                    intervaltime = intervaltime - Agreenrem;
                    Agreenrem = 0;
                    green = mod(green,3) + 1;
                    Amultistop(day) = Amultistop(day) + max(0,Avolmid - time*7.371097925);
                else
                    if (intervaltime < Agreen)
                        time = intervaltime;
                        Agreenrem = Agreen - intervaltime;
                        intervaltime = 0;
                        Avolmid = max(0,Avol - time*7.371097925);
                    else
                        time = Agreen;
                        Amultistop(day) = Amultistop(day) +  max(0,Avol - Agreen*7.371097925);
                        green = mod(green,3) + 1;
                    end;
                end;
                intervaltime = intervaltime - time;
                Ajamtime(day) = Ajamtime(day) + max(0,time - (Avol - 732)/(7.371097925 - Arateinfunction((t + time/2)/(3600*18))));
                Avol = max(0,Avol - time*(7.371097925 - Arateinfunction((t + time/2)/(3600*18))));
                Bjamtime(day) = Bjamtime(day) + max(0,time - max(0,(456 - Bvol)/Brateinfunction((t + time/2)/(3600*18))));
                Bvol = Bvol + time*(Brateinfunction((t + time/2)/(3600*18)));
                CDfilltime = (96 - CDvol)/(Crateinfunction((t + time/2)/(3600*18)) + Drateinfunction((t + time/2)/(3600*18)));
                CDvol = min(CDvol + time*Crateinfunction((t + time/2)/(3600*18)) + time*Drateinfunction((t + time/2)/(3600*18)),96);
                Cjamtime(day) = Cjamtime(day) + max(0,(time - CDfilltime) - max(0,(144 - Cvol)/Crateinfunction((t + (time + CDfilltime)/2)/(3600*18))));
                Cvol = max(0,Crateinfunction((t + time/2)/(3600*18))*(time - CDfilltime));
                Djamtime(day) = Djamtime(day) + max(0,(time - CDfilltime) - max(0,(88 - Dvol)/Drateinfunction((t + (time + CDfilltime)/2)/(3600*18))));
                Dvol = max(0,Drateinfunction((t + time/2)/(3600*18))*(time - CDfilltime));
                t = t + time;
            else if (green == 2)
                if (Bgreenrem > 0)
                    time = Bgreenrem;
                    intervaltime = intervaltime - Bgreenrem;
                    Bgreenrem = 0;
                    green = mod(green,3) + 1;
                    Bmultistop(day) = Bmultistop(day) + max(0,Bvolmid - time*6.379687086);
                else
                    if (intervaltime < Bgreen)
                        time = intervaltime;
                        Bgreenrem = Bgreen - intervaltime;
                        intervaltime = 0;
                        Bvolmid = max(0,Bvol - time*6.379687086);
                    else
                        time = Bgreen;
                        Bmultistop(day) = Bmultistop(day) +  max(0,Bvol - Bgreen*6.379687086);
                        green = mod(green,3) + 1;
                    end;
                end;
                intervaltime = intervaltime - time;
                Ajamtime(day) = Ajamtime(day) + max(0,time - max(0,(732 - Avol)/Arateinfunction((t + time/2)/(3600*18))));
                Avol = Avol + time*(Arateinfunction((t + time/2)/(3600*18)));
                Bjamtime(day) = Bjamtime(day) + max(0,time - max(0,(Bvol - 456)/(6.379687086 - Brateinfunction((t + time/2)/(3600*18)))));
                Bvol = max(0,Bvol - time*(6.379687086 - Brateinfunction((t + time/2)/(3600*18))));
                CDfilltime = (96 - CDvol)/(Crateinfunction(t + time/2) + Drateinfunction((t + time/2)/(3600*18)));
                CDvol = min(CDvol + time*Crateinfunction((t + time/2)/(3600*18)) + time*Drateinfunction((t + time/2)/(3600*18)),96);
                Cjamtime(day) = Cjamtime(day) + max(0,(time - CDfilltime) - max(0,(144 - Cvol)/Crateinfunction((t + (time + CDfilltime)/2)/(3600*18))));
                Cvol = max(0,Crateinfunction((t + time/2)/(3600*18))*(time - CDfilltime));
                Djamtime(day) = Djamtime(day) + max(0,(time - CDfilltime) - max(0,(88 - Dvol)/Drateinfunction((t + (time + CDfilltime)/2)/(3600*18))));
                Dvol = max(0,Drateinfunction((t + time/2)/(3600*18))*(time - CDfilltime));
                t = t + time;
            else if (green == 3)
                if (Cgreenrem > 0)
                    time = Cgreenrem;
                    intervaltime = intervaltime - Cgreenrem;
                    Cgreenrem = 0;
                    green = mod(green,3) + 1;
                    Cmultistop(day) = Cmultistop(day) + max(0,Cvolmid - time*6.150137148);
                else
                    if (intervaltime < Cgreen)
                        time = intervaltime;
                        Cgreenrem = Cgreen - intervaltime;
                        intervaltime = 0;
                        Cvolmid = max(0,Cvol + Dvol + CDvol - time*6.150137148);
                    else
                        time = Cgreen;
                        Cmultistop(day) = Cmultistop(day) + max(0,Cvol + Dvol + CDvol - Cgreen*6.150137148);
                        green = mod(green,3) + 1;
                    end;
                end;
                intervaltime = intervaltime - time;
                Ajamtime(day) = Ajamtime(day) + max(0,time - max(0,(732 - Avol)/Arateinfunction((t + time/2)/(3600*18))));
                Avol = Avol + time*(Arateinfunction((t + time/2)/(3600*18)));
                Bjamtime(day) = Bjamtime(day) + max(0,time - max(0,(456 - Bvol)/Brateinfunction((t + time/2)/(3600*18))));
                Bvol = Bvol + time*(Brateinfunction((t + time/2)/(3600*18)));
                CDvol = max(0,min((Cvol + Dvol + CDvol) - time*(12.300274296 - (Crateinfunction((t + time/2)/(3600*18)) + Drateinfunction((t + time/2)/(3600*18)))),96));
                Cjamtime(day) = Cjamtime(day) + max(0,(Cvol - 144)/6.379687086);
                Cvol = max(0,Cvol - time*(6.150137148 - Crateinfunction((t + time/2)/(3600*18))));
                Djamtime(day) = Djamtime(day) + max(0,(Dvol - 88)/6.379687086);
                Dvol = max(0,Dvol - time*(6.150137148 - Drateinfunction((t + time/2)/(3600*18))));
                t = t + time;
            end;
            end;
            end;
        end;
    end;
    disp([num2str(Amultistop(day)/2.049382),' kendaraan terhenti lebih dari satu kali di sektor 1 di hari ',num2str(day)])
    disp([num2str(Bmultistop(day)/2.049382),' kendaraan terhenti lebih dari satu kali di sektor 2 di hari ',num2str(day)])
    disp([num2str(Cmultistop(day)/2.049382),' kendaraan terhenti lebih dari satu kali di sektor 3 di hari ',num2str(day)])
    disp(['Terjadi kemacetan selama ',num2str(floor(Ajamtime(day)/3600)),' jam ',num2str(floor(mod(Ajamtime(day),3600)/60)),' menit ',num2str(mod(Ajamtime(day),60)),' detik di sektor 1 di hari ',num2str(day)])
    disp(['Terjadi kemacetan selama ',num2str(floor(Bjamtime(day)/3600)),' jam ',num2str(floor(mod(Bjamtime(day),3600)/60)),' menit ',num2str(mod(Bjamtime(day),60)),' detik di sektor 2 di hari ',num2str(day)])
    disp(['Terjadi kemacetan selama ',num2str(floor(Cjamtime(day)/3600)),' jam ',num2str(floor(mod(Cjamtime(day),3600)/60)),' menit ',num2str(mod(Cjamtime(day),60)),' detik di sektor 3 di hari ',num2str(day)])
    disp(['Terjadi kemacetan selama ',num2str(floor(Djamtime(day)/3600)),' jam ',num2str(floor(mod(Djamtime(day),3600)/60)),' menit ',num2str(mod(Djamtime(day),60)),' detik di sektor 4 di hari ',num2str(day)])
end;

end;