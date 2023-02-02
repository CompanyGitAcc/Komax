pageextension 59058 "TP Posted Purch. Rcpt. Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }

    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Quantity, '>%1|<%1', 0, 0);
    end;
}
