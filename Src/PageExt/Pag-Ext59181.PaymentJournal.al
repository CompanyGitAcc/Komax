pageextension 59181 "TP Payment Journal" extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = all;
            }
            // field("Customer Name"; Rec."Customer Name")
            // {
            //     ApplicationArea = all;
            // }
        }
    }


}
