pageextension 59180 "TP Cash Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Account No.")
        {
            // field("Vendor Name"; Rec."Vendor Name")
            // {
            //     ApplicationArea = all;
            // }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }
        }
    }


}
