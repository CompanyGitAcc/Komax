tableextension 59046 "TP Warehouse Receipt Line" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50001; "Location Name"; text[100])
        {
            Caption = 'Location Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        //-YK004
        field(50003; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Direct Unit Cost" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }
        field(50004; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Amount Including VAT" where("Document No." = field("Source No."), "Line No." = field("Source Line No.")));
        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            var
                CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
                Dummy: Decimal;
                WhseCrossDockOpportunity: Record "Whse. Cross-Dock Opportunity";
                WhseCrossDockOpportunity2: Record "Whse. Cross-Dock Opportunity";
                QtyOnCrossDockBase: Decimal;
                QtyNeededSumBase: Decimal;
            begin
                // QtyOnCrossDockBase := 0;
                // WhseCrossDockOpportunity2.Reset();
                // WhseCrossDockOpportunity2.SetRange("Item No.", "Item No.");
                // if WhseCrossDockOpportunity2.FindFirst() then begin
                //     QtyOnCrossDockBase := QtyOnCrossDockBase + WhseCrossDockOpportunity2."Qty. to Cross-Dock";
                // end;
                // QtyOnCrossDockBase := CrossDockMgt.CalcCrossDockReceivedNotCrossDocked("Location Code", "Item No.", "Variant Code");

                // CrossDockMgt.SetTemplate('', Rec."No.", Rec."Location Code");
                // CrossDockMgt.CalculateCrossDockLine(
                //   WhseCrossDockOpportunity, Rec."Item No.", Rec."Variant Code",
                //   QtyNeededSumBase, Dummy, QtyOnCrossDockBase,
                //   Rec."Line No.", Rec."Qty. to Receive (Base)");
                // Rec.QuantityAllocation();
                // "Qty. to Cross-Dock" := "Qty. to Receive";
            end;
        }
    }
    procedure QuantityAllocation();
    var
        // WarehouseReceiptLine: Record "Warehouse Receipt Line";
        WarehouseReceiptLineQty: Decimal;
        WhseCrossDockOpportunity2: Record "Whse. Cross-Dock Opportunity";
    begin
        WarehouseReceiptLineQty := Rec."Qty. to Receive";
        WhseCrossDockOpportunity2.Reset();
        WhseCrossDockOpportunity2.SetRange("Source Name/No.", Rec."No.");
        WhseCrossDockOpportunity2.SetRange("Item No.", Rec."Item No.");
        WhseCrossDockOpportunity2.SetRange("Location Code", Rec."Location Code");
        WhseCrossDockOpportunity2.SETCURRENTKEY("Due Date");
        WhseCrossDockOpportunity2.SETASCENDING("Due Date", true);
        if WhseCrossDockOpportunity2.FindFirst() then
            repeat
                if WarehouseReceiptLineQty > WhseCrossDockOpportunity2."Qty. Needed" then begin
                    WhseCrossDockOpportunity2."Qty. to Cross-Dock" := WhseCrossDockOpportunity2."Qty. Needed";
                    WarehouseReceiptLineQty := WarehouseReceiptLineQty - WhseCrossDockOpportunity2."Qty. Needed";
                end else begin
                    WhseCrossDockOpportunity2."Qty. to Cross-Dock" := WarehouseReceiptLineQty;
                    WarehouseReceiptLineQty := 0;
                end;
                WhseCrossDockOpportunity2.Modify();

            until WhseCrossDockOpportunity2.Next() = 0;

    end;
}
