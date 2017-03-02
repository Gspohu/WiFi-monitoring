#!/bin/bash

echo "0 0" > gain
echo "0 0" > latence
echo "0 0" > loss

temps=0
keypress="z"

echo "set terminal pdf enhanced background rgb '#F5F5F5'" > gnuplot_script_img
echo "set output 'curve.pdf'" >> gnuplot_script_img
echo "set autoscale" >> gnuplot_script_img
echo "set xtic auto" >> gnuplot_script_img
echo "set ytic auto" >> gnuplot_script_img
echo "set title 'Monitoring WiFi'" >> gnuplot_script_img
echo "set ylabel 'Gain'" >> gnuplot_script_img
echo "set xlabel 'Temps'" >> gnuplot_script_img
echo "set yr [0:100]" >> gnuplot_script_img
echo "plot 'gain' with lines linecolor rgb '#AD08A2' lw 3. , 'latence' with lines linecolor rgb '#650EAD' lw 3. , 'loss' with lines linecolor rgb '#C90003' lw 3. " >> gnuplot_script_img

##Live##
echo "set autoscale" > gnuplot_script
echo "set xtic auto" >> gnuplot_script
echo "set ytic auto" >> gnuplot_script
echo "set title 'Monitoring WiFi'" >> gnuplot_script
echo "set ylabel 'Gain'" >> gnuplot_script
echo "set xlabel 'Temps'" >> gnuplot_script
echo "set yr [0:100]" >> gnuplot_script
echo "plot 'gain' with lines linecolor rgb '#AD08A2' lw 3. " >> gnuplot_script
echo "replot 'latence' with lines linecolor rgb '#650EAD' lw 3. " >> gnuplot_script
echo "replot 'loss' with lines linecolor rgb '#C90003' lw 3. " >> gnuplot_script
echo "pause 1" >> gnuplot_script
echo "reread" >> gnuplot_script


while [ "$keypress" != "q" ] 
do
	link=$(awk 'NR==3 {print  $3 "00 "}''' /proc/net/wireless) 
	level=$(awk 'NR==3 {print  $4 }''' /proc/net/wireless)
	noise=$(awk 'NR==3 {print  $5 }''' /proc/net/wireless)
	pong=$(ping -i 0,5 -c 5 www.ovh.com)
	loss=$(echo $pong | cut  -d \, -f 3 | cut -d \p -f 1)
	latence=$(echo $pong | cut  -d \/ -f 5 | cut -d \/ -f 6)

	echo "$temps"" ""$link" >> gain
	echo "$temps"" ""$latence" >> latence
	echo "$temps"" ""$loss" >> loss
	
	##PLOT##
	if [ $temps -eq 3 ]
	then
		gnuplot gnuplot_script &
		gnuplot gnuplot_script_img 
	fi
	if [ $temps -gt 3 ]
        then
                gnuplot gnuplot_script_img
        fi
				
	sleep 0.2
	((temps++))
done
