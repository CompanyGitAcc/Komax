pageextension 59164 "TP Employee List" extends "Employee List"
{
    layout
    {
        addlast(Control1)
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = all;
            }
        }
        addafter(Balance)
        {
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Bank Branch No."; Rec."Bank Branch No.")
            {
                ApplicationArea = all;
            }
        }
    }



}
