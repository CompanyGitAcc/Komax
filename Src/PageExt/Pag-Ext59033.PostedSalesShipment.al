pageextension 59033 "TP Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
        }
        addafter("Ship-to Contact")
        {
            field("Ship-to Phone No."; Rec."Ship-to Phone No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Print Posted Sales Shipment")
            {
                Caption = 'Print Posted Sales Shipment';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    SalesShipment: Report "Sales Shipment";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    // Currpage.setselectionfilter(SalesShipmentHeader);
                    SalesShipmentHeader.SetRange("No.", Rec."No.");
                    SalesShipment.Settableview(SalesShipmentHeader);
                    SalesShipment.Runmodal();
                end;
            }
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";
}
