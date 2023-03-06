pageextension 59084 "TP Warehouse Shipment" extends "Warehouse Shipment"
{
    layout
    {
        // addafter(Shipping)
        // {
        //     group("Ship-to")
        //     {
        //         Caption = 'Ship-to';
        //         field("Ship-to Type"; Rec."Ship-to Type")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("Ship-to No."; Rec."Ship-to No.")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field(Name; Rec."Ship-to Name")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("Ship-to Address Code"; Rec."Ship-to Address Code")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field(Address; Rec."Ship-to Address")
        //         {
        //             ShowMandatory = true;
        //             ApplicationArea = all;
        //         }
        //         field("Phone No."; Rec."Ship-to Phone No.")
        //         {
        //             ShowMandatory = true;
        //             ApplicationArea = all;
        //         }
        //         field(Contact; Rec."Ship-to Contact")
        //         {
        //             ShowMandatory = true;
        //             ApplicationArea = all;
        //         }
        //     }
        // }

        addlast(General)
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }

        }
    }

    actions
    {
        addafter("&Print")
        {
            //期初
            // action("Set Openning Shipment")
            // {
            //     Caption = 'Set Openning Shipment';
            //     Image = ReleaseDoc;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Visible = false;

            //     trigger OnAction()
            //     var
            //         WarehouseLine: Record "Warehouse Shipment Line";
            //         SalesLine: Record "Sales Line";
            //         window: Dialog;
            //     begin
            //         window.Open('Updating#1###########');
            //         WarehouseLine.SetRange("No.", Rec."No.");
            //         if WarehouseLine.FindFirst() then
            //             repeat
            //                 window.Update(1, Format(WarehouseLine."Line No."));
            //                 SalesLine.get(salesline."Document Type"::Order, WarehouseLine."Source No.", WarehouseLine."Source Line No.");
            //                 if SalesLine."Post Qty" <> 0 then begin
            //                     WarehouseLine.Validate("Bin Code", 'OPEN');
            //                     WarehouseLine.Validate("Qty. to Ship", SalesLine."Post Qty" - SalesLine."Quantity Shipped");
            //                 end else begin
            //                     WarehouseLine.Validate("Bin Code", 'OPEN');
            //                     WarehouseLine.Validate("Qty. to Ship", 0);
            //                 end;
            //                 WarehouseLine.Modify();
            //             until WarehouseLine.Next() = 0;
            //         window.Close();
            //     end;
            // }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
