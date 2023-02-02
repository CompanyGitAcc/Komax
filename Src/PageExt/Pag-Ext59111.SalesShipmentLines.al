pageextension 59111 "TP Sales Shipment Lines" extends "Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = all;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
            field("Sales Order No"; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            // field("Komax Reason Code"; Rec."Komax Reason Code")
            // {
            //     ApplicationArea = all;
            // }
        }
        addafter("Unit of Measure Code")
        {
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
        }
    }
}
