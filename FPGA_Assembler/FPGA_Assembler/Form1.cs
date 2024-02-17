using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace FPGA_Assembler
{
    public partial class Form1 : Form
    {
        Dictionary<string, string> all_instructions =
              new Dictionary<string, string>(){
            {"ADD_B", "00000000"},
            {"ADD_C", "00000001"},
            {"ADD_M", "00000010"},
            {"SUB_B", "00000011"},
            {"SUB_C", "00000100"},
            {"SUB_M", "00000101"},
            {"OR_B", "00000110"},
            {"OR_C", "00000111"},
            {"OR_M", "00001000"},
            {"AND_B", "00001001"},
            {"AND_C", "00001010"},
            {"AND_M", "00001011"},
            {"XOR_B", "00001100"},
            {"XOR_C", "00001101"},
            {"XOR_M", "00001110"},
            {"JMP", "00001111"},
            {"JMP_C", "00010000"},
            {"JMP_P", "00010001"},
            {"JMP_S", "00010010"},
            {"JMP_Z", "00010011"},
            {"CALL", "00010100"},
            {"CALL_C", "00010101"},
            {"CALL_P", "00010110"},
            {"CALL_S", "00010111"},
            {"CALL_Z", "00011000"},
            {"RET", "00011001"},
            {"RL", "00011010"},
            {"RR", "00011011"},
            {"OUT", "00011100"},
            {"INC_A", "00011101"},
            {"INC_B", "00011110"},
            {"INC_C", "00011111"},
            {"DRC_A", "00100000"},
            {"DRC_B", "00100001"},
            {"DRC_C", "00100010"},
            {"CLR_A", "00100011"},
            {"CLR_B", "00100100"},
            {"CLR_C", "00100101"},
            {"CPL_A", "00100110"},
            {"CPL_B", "00100111"},
            {"CPL_C", "00101000"},
            {"ADI", "00101011"},
            {"SBI", "00101100"},
            {"ORI", "00101101"},
            {"ANI", "00101110"},
            {"XRI", "00101111"},
            {"MOV_AB", "00110000"},
            {"MOV_BC", "00110001"},
            {"MOV_CB", "00110010"},
            {"MOV_AC", "00110011"},
            {"MVI_A", "00110100"},
            {"MVI_B", "00110101"},
            {"MVI_C", "00110110"},
            {"PUSH", "00110111"},
            {"POP", "00111000"},
            {"NOP", "00111001"},
            {"XCH_A_B", "00111010"},
            {"XCH_A_C", "00111011"},
            {"XCH_B_C", "00111100"},
            {"XCHD_A", "00111101"},
            {"XCHD_B", "00111110"},
            {"XCHD_C", "00111111"},
            {"HLT", "11111111"}};
        String[] multy_byte_instructions = { "ADI", "SBI", "ORI", "ANI", "XRI", "MVI_A", "MVI_B", "MVI_C" };
        List<string> instructions = new List<string>();
        String opcode;
        String value;
        List<string> output = new List<string>();
        bool detect_error = false;
        int i;
        bool isChecked = true;
        int current_output_format = 2;

        public Form1()
        {
            InitializeComponent();
            checkBox1.Checked = isChecked;
            richTextBox3.AppendText("0000\n");
            current_output_format = 2;
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            isChecked = checkBox1.Checked;
            if (isChecked)
            {
                checkBox1.Text = "RUNNING";
                try
                {
                    assembler();
                }
                catch (Exception)
                {
                    //MessageBox.Show("something wrong");
                }
                if (detect_error)
                {
                    output.Clear();
                }
                label1.Text = Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0');
                richTextBox2.Lines = output.ToArray();
            }
            else
            {
                checkBox1.Text = "PAUSE";
            }
        }
        
        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {
            if (isChecked)
            {
                try
                {
                    assembler();
                }
                catch (Exception)
                {
                    //MessageBox.Show("something wrong");
                }
            }
            if(detect_error)
            {
                output.Clear();
            }
            label1.Text = Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0');
            richTextBox2.Lines = output.ToArray();
            richTextBox3.SelectionStart = richTextBox1.SelectionStart;
            richTextBox3.ScrollToCaret();
            vScrollBar1.Minimum = 0;
            vScrollBar1.Maximum = richTextBox1.Lines.Count() - 1;
            current_output_format = 2;
        }

        private void assembler()
        {
            output.Clear();
            richTextBox3.Clear();
            detect_error = false;
            List<string> myList = richTextBox1.Lines.ToList();
            myList = myList.ConvertAll(d => d.ToUpper());
            richTextBox1.Clear();
            richTextBox1.Lines = myList.ToArray();
            richTextBox1.Refresh();
            richTextBox1.SelectionStart = richTextBox1.Text.Length;
            richTextBox1.ScrollToCaret();
            instructions = richTextBox1.Lines.ToList();
            if (instructions.Count() > 1)
            {
                for (i = 0; i < instructions.Count() - 1; i++)
                {
                    convert_to_assembly(instructions[i].ToUpper());
                }
            }
            else
            {
                convert_to_assembly(instructions[0].ToUpper());
            }
        }

        private void convert_to_assembly(String instruction)
        {
            if (instruction.IndexOf(',') > 0)
            {
                opcode = instruction.Split(',')[0].Trim();
                value = instruction.Split(',')[1].Trim();
                if(all_instructions.ContainsKey(opcode))
                {
                    output.Add(all_instructions[opcode]);
                    
                    if (value.Length > 2)
                    {
                        if (value[value.Length - 1] == 'H')
                        {
                            value = value.Remove(value.Length - 1);
                            if (Regex.IsMatch(value, @"[0-9A-F]{2}\b"))
                            {
                                output.Add(Convert.ToString(Convert.ToByte(value, 16), 2).PadLeft(8, '0'));
                                richTextBox3.AppendText(Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0') + "\r\n");
                            }
                            else
                            {
                                output.RemoveAt(output.Count - 1);
                                if (i + 1 < richTextBox1.Lines.Count())
                                {
                                    if (richTextBox1.Lines[i + 1].Length == 0)
                                    {
                                        List<string> temp = richTextBox1.Lines.ToList();
                                        temp.RemoveAt(i + 1);
                                        richTextBox1.Lines = temp.ToArray();
                                    }
                                }
                                richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(i), richTextBox1.Lines[i].Length);
                                richTextBox1.SelectionColor = Color.Red;
                                richTextBox1.DeselectAll();
                                // set the current caret position to the end
                                richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                                // scroll it automatically
                                richTextBox1.ScrollToCaret();
                                detect_error = true;
                            }
                        }
                        else
                        {
                            output.RemoveAt(output.Count - 1);
                            if (i + 1 < richTextBox1.Lines.Count())
                            {
                                if (richTextBox1.Lines[i + 1].Length == 0)
                                {
                                    List<string> temp = richTextBox1.Lines.ToList();
                                    temp.RemoveAt(i + 1);
                                    richTextBox1.Lines = temp.ToArray();
                                }
                            }
                            richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(i), richTextBox1.Lines[i].Length);
                            richTextBox1.SelectionColor = Color.Red;
                            richTextBox1.DeselectAll();
                            // set the current caret position to the end
                            richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                            // scroll it automatically
                            richTextBox1.ScrollToCaret();
                            detect_error = true;
                        }
                    }
                    else
                    {
                        output.RemoveAt(output.Count - 1);
                        if (i + 1 < richTextBox1.Lines.Count())
                        {
                            if (richTextBox1.Lines[i + 1].Length == 0)
                            {
                                List<string> temp = richTextBox1.Lines.ToList();
                                temp.RemoveAt(i + 1);
                                richTextBox1.Lines = temp.ToArray();
                            }
                        }
                        richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(i), richTextBox1.Lines[i].Length);
                        richTextBox1.SelectionColor = Color.Red;
                        richTextBox1.DeselectAll();
                        // set the current caret position to the end
                        richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                        // scroll it automatically
                        richTextBox1.ScrollToCaret();
                        detect_error = true;
                    }
                }
                else
                {
                    if (i + 1 < richTextBox1.Lines.Count())
                    {
                        if (richTextBox1.Lines[i + 1].Length == 0)
                        {
                            List<string> temp = richTextBox1.Lines.ToList();
                            temp.RemoveAt(i + 1);
                            richTextBox1.Lines = temp.ToArray();
                        }
                    }
                    richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(i), richTextBox1.Lines[i].Length);
                    richTextBox1.SelectionColor = Color.Red;
                    richTextBox1.DeselectAll();
                    // set the current caret position to the end
                    richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                    // scroll it automatically
                    richTextBox1.ScrollToCaret();
                    detect_error = true;
                }
            }
            else
            {
                opcode = instruction.Trim();
                if(multy_byte_instructions.Contains(opcode))
                {
                    if (i + 1 < richTextBox1.Lines.Count())
                    {
                        if (richTextBox1.Lines[i + 1].Length == 0)
                        {
                            List<string> temp = richTextBox1.Lines.ToList();
                            temp.RemoveAt(i + 1);
                            richTextBox1.Lines = temp.ToArray();
                        }
                    }               
                    richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(i), richTextBox1.Lines[i].Length);
                    richTextBox1.SelectionColor = Color.Red;
                    richTextBox1.DeselectAll();
                    // set the current caret position to the end
                    richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                    // scroll it automatically
                    richTextBox1.ScrollToCaret();
                    detect_error = true;
                }
                else
                {
                    if (all_instructions.ContainsKey(opcode))
                    {
                        output.Add(all_instructions[opcode]);
                        richTextBox3.AppendText(Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0') + "\r\n");
                    }
                    else
                    {
                        if (opcode.Length == 0)
                        {
                            output.Add("11111111");
                            richTextBox3.AppendText(Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0') + "\r\n");
                        }
                        else
                        {
                            List<string> myList = richTextBox1.Lines.ToList();
                            myList = myList.ConvertAll(d => d.ToUpper());
                            if (myList.Count > 1)
                            {
                                myList.RemoveAt(i);
                                richTextBox1.Lines = myList.ToArray();
                                richTextBox1.Refresh();
                                // set the current caret position to the end
                                richTextBox1.SelectionStart = richTextBox1.GetFirstCharIndexFromLine(i) + richTextBox1.Lines[i].Length;
                                // scroll it automatically
                                richTextBox1.ScrollToCaret();
                            }
                        }
                    }
                }
            }
        }
        
        private void vScrollBar1_Scroll(object sender, ScrollEventArgs e)
        {
            try
            {
                richTextBox1.Select(richTextBox1.GetFirstCharIndexFromLine(vScrollBar1.Value), 0);
                richTextBox3.Select(richTextBox3.GetFirstCharIndexFromLine(vScrollBar1.Value), 0);
                richTextBox1.ScrollToCaret();
                richTextBox3.ScrollToCaret();
            }
            catch (Exception)
            {

            }
        }

        private void paddAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            richTextBox1.AppendText("\n");
            for (int m = output.Count(); m < 8192; m++)
            {
                output.Add("11111111");
            }
            richTextBox2.Lines = output.ToArray();
        }

        private void clearAllToolStripMenuItem_Click(object sender, EventArgs e)
        {
            richTextBox1.Clear();
            try
            {
                assembler();
            }
            catch (Exception)
            {
                //MessageBox.Show("something wrong");
            }
            label1.Text = Convert.ToString(output.Count(), 16).ToUpper().PadLeft(4, '0');
            richTextBox2.Lines = output.ToArray();
            richTextBox3.SelectionStart = richTextBox1.SelectionStart;
            richTextBox3.ScrollToCaret();
            vScrollBar1.Minimum = 0;
            vScrollBar1.Maximum = richTextBox1.Lines.Count() - 1;
            current_output_format = 2;
        }

        private void convertToBinToolStripMenuItem_Click(object sender, EventArgs e)
        {
            List<string> myList = richTextBox2.Lines.ToList();
            myList = myList.ConvertAll(d => Convert.ToString(Convert.ToByte(d, current_output_format), 2).PadLeft(8, '0'));
            if (myList.Count > 1)
            {
                richTextBox2.Lines = myList.ToArray();
                richTextBox2.Refresh();
                current_output_format = 2;
            }
        }

        private void convertToDecToolStripMenuItem_Click(object sender, EventArgs e)
        {
            List<string> myList = richTextBox2.Lines.ToList();
            myList = myList.ConvertAll(d => Convert.ToString(Convert.ToByte(d, current_output_format), 10).PadLeft(3, '0'));
            if (myList.Count > 1)
            {
                richTextBox2.Lines = myList.ToArray();
                richTextBox2.Refresh();
                current_output_format = 10;
            }
        }

        private void convertToHexToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            List<string> myList = richTextBox2.Lines.ToList();
            myList = myList.ConvertAll(d => Convert.ToString(Convert.ToByte(d, current_output_format), 16).PadLeft(2, '0').ToUpper());
            if (myList.Count > 1)
            {
                richTextBox2.Lines = myList.ToArray();
                richTextBox2.Refresh();
                current_output_format = 16;
            }
        }
    }
}
