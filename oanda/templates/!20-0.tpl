<chart>
comment=
symbol=USDJPY
period=1440
leftpos=11405
digits=3
scale=2
graph=0
fore=0
grid=0
volume=0
scroll=1
shift=1
ohlc=1
one_click=0
askline=1
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=22
window_top=22
window_right=822
window_bottom=343
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=133
<indicator>
name=main
<object>
type=0
object_name=end
period_flags=0
create_time=1373186497
color=65535
style=0
weight=1
background=0
time_0=1373043595
</object>
<object>
type=23
object_name=fpips
period_flags=0
create_time=1373186497
description=Pips Travelled: 3875
color=16777215
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=130
</object>
<object>
type=23
object_name=gtotal
period_flags=0
create_time=1373186497
description=3875
color=65535
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=70
</object>
<object>
type=23
object_name=pips
period_flags=0
create_time=1373186497
description=Pips Earned: 3875
color=16777215
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=50
</object>
<object>
type=23
object_name=sname
period_flags=0
create_time=1373186497
description=Strategy Name: 
color=16777215
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=90
</object>
<object>
type=23
object_name=snameval
period_flags=0
create_time=1373186497
description=macdRshift
color=65535
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=110
</object>
<object>
type=0
object_name=start
period_flags=0
create_time=1373186497
color=65535
style=0
weight=1
background=0
time_0=1371315595
</object>
<object>
type=23
object_name=startdate
period_flags=0
create_time=1373186497
description=2013.06.15 16:59 to 2013.07.05 16:59
color=65535
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=30
</object>
<object>
type=23
object_name=strategy
period_flags=0
create_time=1373186497
description=Strategy: 4
color=16777215
font=Verdana
fontsize=10
angle=0
background=0
corner=1
x_distance=10
y_distance=10
</object>
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=cuBestStrategyTimeClose
flags=339
window_num=0
<inputs>
noofdays=20
noofdaysend=0
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=65535
style_0=0
weight_0=2
arrow_0=233
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=2
arrow_1=234
shift_2=0
draw_2=12
color_2=0
style_2=0
weight_2=0
shift_3=0
draw_3=12
color_3=0
style_3=0
weight_3=0
shift_4=0
draw_4=12
color_4=0
style_4=0
weight_4=0
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=17
<indicator>
name=MACD
fast_ema=12
slow_ema=26
macd_sma=9
apply=0
color=12632256
style=0
weight=1
signal_color=255
signal_style=2
signal_weight=1
period_flags=0
show_data=1
</indicator>
</window>
</chart>

