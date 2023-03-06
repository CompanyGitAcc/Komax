pageextension 59130 "TP Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Default Sales Type on Invoice"; Rec."Default Sales Type on Invoice")
            {
                ApplicationArea = all;
            }

        }
    }

}
