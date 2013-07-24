<chart>
symbol=AUDUSD
period=1440
leftpos=1963
digits=5
scale=8
graph=1
fore=0
grid=1
volume=0
scroll=1
shift=1
ohlc=1
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=132
window_top=132
window_right=921
window_bottom=476
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
height=141
<indicator>
name=main
<object>
type=1
object_name=Horizontal Line 42441
period_flags=0
create_time=1364108745
color=255
style=0
weight=1
background=0
value_0=1.061526
</object>
<object>
type=1
object_name=Horizontal Line 42449
period_flags=0
create_time=1364108753
color=255
style=0
weight=1
background=0
value_0=1.010561
</object>
</indicator>
<indicator>
name=Bollinger Bands
period=20
shift=0
deviations=2
apply=0
color=7451452
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=z_macdStoch
flags=339
window_num=0
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
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=41
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

<window>
height=18
<indicator>
name=Stochastic Oscillator
kperiod=14
dperiod=3
slowing=3
method=0
apply=0
color=11186720
style=0
weight=1
color2=255
style2=2
weight2=1
min=0.000000
max=100.000000
levels_color=12632256
levels_style=2
levels_weight=1
level_0=20.0000
level_1=80.0000
period_flags=0
show_data=1
</indicator>
</window>
</chart>

