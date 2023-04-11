# WPF

## Transparent window with the possibility of stretching
```xaml
<Window x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="#11FFFFFF">
    <WindowChrome.WindowChrome>
        <WindowChrome 
        CaptionHeight="0"
        ResizeBorderThickness="5" />
    </WindowChrome.WindowChrome>
    <Grid>

    </Grid>
</Window>
```
