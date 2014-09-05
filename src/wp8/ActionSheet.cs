using Microsoft.Phone.Tasks;
using WPCordovaClassLib.Cordova;
using WPCordovaClassLib.Cordova.Commands;
using WPCordovaClassLib.Cordova.JSON;
using System.Runtime.Serialization;
using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;

namespace Cordova.Extension.Commands
{
    public class ActionSheet : BaseCommand
    {

        [DataContract]
        public class ActionSheetOptions
        {
            [DataMember(IsRequired = true, Name = "buttonLabels")]
            public string[] buttonLabels { get; set; }

            [DataMember(IsRequired = false, Name = "title")]
            public string title { get; set; }

            [DataMember(IsRequired = false, Name = "addCancelButtonWithLabel")]
            public string addCancelButtonWithLabel { get; set; }

            [DataMember(IsRequired = false, Name = "addDestructiveButtonWithLabel")]
            public string addDestructiveButtonWithLabel { get; set; }
        }

        private ActionSheetOptions actionSheetOptions = null;

        private Popup popup = new Popup();

        public void show(string options)
        {
            try
            {
                String jsonOptions = JsonHelper.Deserialize<string[]>(options)[0];
                actionSheetOptions = JsonHelper.Deserialize<ActionSheetOptions>(jsonOptions);
            }
            catch (Exception)
            {
                DispatchCommandResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
                return;
            }

            Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    Border border = new Border();
                    border.Width = Application.Current.Host.Content.ActualWidth - 40;
                    border.Background = new SolidColorBrush(Color.FromArgb(240, 40, 40, 40));
                    border.CornerRadius = new CornerRadius(6);
                    border.Padding = new Thickness(10, 10, 10, 10);


                    // container for the buttons
                    StackPanel panel = new StackPanel();
                    panel.HorizontalAlignment = HorizontalAlignment.Stretch;
                    panel.VerticalAlignment = VerticalAlignment.Center;
                    panel.Width = Application.Current.Host.Content.ActualWidth - 60;


                    // title
                    if (actionSheetOptions.title != null)
                    {
                        TextBlock textblock1 = new TextBlock();
                        textblock1.Text = actionSheetOptions.title;
                        textblock1.Margin = new Thickness(20, 10, 20, 0); // left, top, right, bottom
                        textblock1.FontSize = 22;
                        textblock1.Foreground = new SolidColorBrush(Colors.White);
                        panel.Children.Add(textblock1);
                    }

                    int buttonIndex = 1;

                    // desctructive button
                    if (actionSheetOptions.addDestructiveButtonWithLabel != null)
                    {
                        Button button = new Button();
                        button.TabIndex = buttonIndex++;
                        button.Content = actionSheetOptions.addDestructiveButtonWithLabel;
                        button.HorizontalContentAlignment = HorizontalAlignment.Left;
                        button.Background = new SolidColorBrush(Colors.White);
                        button.Foreground = new SolidColorBrush(Colors.Red);
                        button.Padding = new Thickness(10);
                        button.Margin = new Thickness(5);
                        button.Click += new RoutedEventHandler(buttonClickListener);
                        panel.Children.Add(button);

                    }


                    // regular buttons
                    foreach (String buttonLabel in actionSheetOptions.buttonLabels) {
                        Button button = new Button();
                        button.TabIndex = buttonIndex++;
                        button.Content = buttonLabel;
                        button.HorizontalContentAlignment = HorizontalAlignment.Left;
                        button.Background = new SolidColorBrush(Colors.White);
                        button.Foreground = new SolidColorBrush(Colors.Black);
                        button.Padding = new Thickness(10);
                        button.Margin = new Thickness(5);
                        button.Click += new RoutedEventHandler(buttonClickListener);
                        panel.Children.Add(button);
                    }

                    // cancel button
                    if (actionSheetOptions.addCancelButtonWithLabel != null)
                    {
                        Button button = new Button();
                        button.TabIndex = buttonIndex++;
                        button.Content = actionSheetOptions.addCancelButtonWithLabel;
                        button.Margin = new Thickness(60, 0, 60, 5);
                        button.FontSize = 18;
                        button.Background = new SolidColorBrush(Colors.LightGray);
                        button.Foreground = new SolidColorBrush(Colors.Black);

                        button.Click += new RoutedEventHandler(buttonClickListener);
                        panel.Children.Add(button);

                    }

                    border.Child = panel;
                    popup.Child = border;

                    // Set where the popup will show up on the screen.
                    popup.VerticalOffset = 34;
                    popup.Margin = new Thickness(20);

                    // TODO I'd rather align the popup to the bottom instead of at the top

                    // TODO It would be nice if we could dim the webview a bit while showing the popup

                    // Open the popup.
                    popup.IsOpen = true;
                });
        }

        void buttonClickListener(object sender, RoutedEventArgs e)
        {
            // Close the popup.
            popup.IsOpen = false;

            // Get the clicked button index
            Button button = (Button)sender;
            DispatchCommandResult(new PluginResult(PluginResult.Status.OK, button.TabIndex));
        }
    }
}