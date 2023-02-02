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
    }



}
