clear
cd "Z:\pma\admin\staff\Devon\research\papers\seasonality\2020\July\easerved"
set more off

*do 01_create_sdp_files.do
do 02_create_wideform_hhf.do
do 03_create_longform_hhf.do
do 04_divide_files.do
do 05_check_files.do
