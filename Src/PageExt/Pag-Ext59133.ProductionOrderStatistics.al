pageextension 59133 "TP Production Order Statistics" extends "Production Order Statistics"
{
    layout
    {
        addlast("Actual Cost")
        {
            field("Actual Component Cost Amt."; Rec."Actual Component Cost Amt.")
            {
                ApplicationArea = all;
            }
            field("Seclect Run Report"; Rec."Seclect Run Report")
            {
                ApplicationArea = all;
            }

        }
    }

}
