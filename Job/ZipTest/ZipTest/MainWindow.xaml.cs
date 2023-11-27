using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Windows;
using System.Windows.Forms;

namespace ZipTest
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow
    {
        public MainWindow() { InitializeComponent(); }

        private void ButtonPack_OnClick(object sender, RoutedEventArgs e)
        {
            using (FolderBrowserDialog fbd = new FolderBrowserDialog())
            {
                if (fbd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    DirectoryInfo directoryInfo = new DirectoryInfo(fbd.SelectedPath);
                    FileInfo[] fileInfoArr = directoryInfo.GetFiles();
                    using (FileStream fileStream =
                           new FileStream(Path.Combine(fbd.SelectedPath, "test.zip"), FileMode.Create))
                    {
                        using (ZipArchive zipArchive =
                               new ZipArchive(fileStream, ZipArchiveMode.Create, false, Encoding.GetEncoding(866)))
                        {
                            foreach (FileInfo fileInfo in fileInfoArr)
                            {
                                ZipArchiveEntry archiveEntry =
                                    zipArchive.CreateEntry(fileInfo.Name, CompressionLevel.Optimal);
                                using (Stream input = fileInfo.OpenRead())
                                {
                                    using (Stream entryStream = archiveEntry.Open())
                                    {
                                        input.Seek(0, SeekOrigin.Begin);
                                        input.CopyTo(entryStream);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private void ButtonUnPack_OnClick(object sender, RoutedEventArgs e)
        {
            using (FolderBrowserDialog fbd = new FolderBrowserDialog())
            {
                if (fbd.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                {
                    using (FileStream fileStream =
                           new FileStream(Path.Combine(fbd.SelectedPath, "test.zip"), FileMode.Open))
                    {
                        using (ZipArchive zipArchive =
                               new ZipArchive(fileStream, ZipArchiveMode.Read, false, Encoding.GetEncoding(866)))
                        {
                            foreach (ZipArchiveEntry archiveEntry in zipArchive.Entries)
                            {
                                string outputPath = Path.Combine(fbd.SelectedPath, archiveEntry.FullName);
                                archiveEntry.ExtractToFile(outputPath, true);
                            }
                        }
                    }
                }
            }
        }
    }
}