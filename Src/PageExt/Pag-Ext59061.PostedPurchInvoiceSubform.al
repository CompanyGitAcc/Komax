pageextension 59061 "TP Posted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        //++YK004-HH220101
        addbefore(Quantity)
        {
            field("Location Name"; REC."Location Name")
            {
                ApplicationArea = ALL;
            }
        }
        //--YK004
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
