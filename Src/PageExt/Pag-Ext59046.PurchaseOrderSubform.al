pageextension 59046 "TP Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {

        //++YK004-HH220101
        modify("Blanket Order No.")
        {
            Visible = true;
        }
        modify("Blanket Order Line No.")
        {
            Visible = true;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify(Quantity)
        {
            ShowMandatory = NOT IsCommentLine;
        }
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = NOT IsCommentLine;
        }
        modify("Location Code")
        {
            ShowMandatory = NOT IsCommentLine;
        }
        modify("No.")
        {
            ShowMandatory = NOT IsCommentLine;
        }
        addafter("Total Amount Incl. VAT")
        {
            field("Total Quantity"; TotalQuantity)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Total Quantity';
                Editable = false;
            }
            field("Line Quantity"; LineQuantity)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Line Quantity';
                Editable = false;
            }
        }

        modify("Appl.-to Item Entry")
        {
            Visible = true;
        }
        movelast(Control1; "Appl.-to Item Entry", "Line No.")

        addlast(Control1)
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
            // field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            // {
            //     ApplicationArea = all;
            // }
            // field("Vendor Item #"; Rec."Vendor Item #")
            // {
            //     ApplicationArea = all;
            // }
            field("Purchaser Code"; Rec."Purchaser Code")
            {
                ApplicationArea = all;
            }
            // field("Shelf No."; Rec."Shelf No.")
            // {
            //     ApplicationArea = all;
            // }
            // field("OC Date"; Rec."OC Date")
            // {
            //     ApplicationArea = all;
            // }
            // field("Pre-Receipt Bin Code"; Rec."Pre-Receipt Bin Code")
            // {
            //     ApplicationArea = all;
            // }
            // field("Drawing Status"; Rec."Drawing Status")
            // {
            //     ApplicationArea = all;
            // }
            // field("Drawing"; Rec."Drawing")
            // {
            //     ApplicationArea = all;
            // }
            // field("Komax CH Part#"; Rec."Komax CH Part#")
            // {
            //     ApplicationArea = all;
            // }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
            }
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
            }
            field("OC Date"; Rec."OC Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Bin Code")
        {
            Visible = false;
        }

        addafter("Quantity Invoiced")
        {
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = all;
            }
        }
        modify("Line No.")
        {
            Visible = true;
        }
        moveafter("Item Reference No."; "Line No.")
    }
    actions
    {
        addlast("F&unctions")
        {

        }
    }



    procedure AddItems(OrderNo: Code[20]; SelectionFilter: Text)
    var
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        LastLineNo: Integer;
    begin
        PurchLine2.Reset();
        PurchLine2.SetRange("Document Type", Rec."Document Type");
        PurchLine2.SetRange("No.", Rec."Document No.");
        if PurchLine2.FindLast() then
            LastLineNo := PurchLine2."Line No." + 10000
        else
            LastLineNo := 10000;

        SalesLine.Reset();
        SalesLine.SETRANGE("Document No.", OrderNo);
        SalesLine.SETFILTER("Outstanding Quantity", '<>0');
        SalesLine.SETFILTER("Line No.", SelectionFilter);
        IF SalesLine.FINDFIRST THEN
            REPEAT
                //检查是否存在相同的Item+Variant
                /*
                PurchLine2.SetRange(Type, PurchLine2.Type::Item);
                PurchLine2.SetRange("No.", SalesLine."No.");
                PurchLine2.SetRange("Variant Code", SalesLine."Variant Code");
                if PurchLine2.FindFirst() then
                    Error(Text001, SalesLine."No.", SalesLine."Variant Code");
                    */
                //插入订单行
                PurchLine.INIT;
                PurchLine."Document Type" := Rec."Document Type";
                PurchLine."Document No." := Rec."Document No.";
                PurchLine."Line No." := LastLineNo;
                PurchLine.Type := SalesLine.Type;
                PurchLine.VALIDATE("No.", SalesLine."No.");
                PurchLine.VALIDATE("Variant Code", SalesLine."Variant Code");
                PurchLine.VALIDATE(Quantity, SalesLine.Quantity);
                PurchLine.VALIDATE("Gross Weight", SalesLine."Gross Weight");
                PurchLine.VALIDATE("Net Weight", SalesLine."Net Weight");
                PurchLine.VALIDATE("Unit Volume", SalesLine."Unit Volume");
                PurchLine.VALIDATE("Location Code", SalesLine."Location Code");
                PurchLine.Validate("Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 1 Code");
                PurchLine.Validate("Shortcut Dimension 2 Code", SalesLine."Shortcut Dimension 2 Code");

                PurchLine.INSERT(TRUE);
                LastLineNo := LastLineNo + 10000;
            UNTIL SalesLine.NEXT = 0;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        PurchaseLineType: Enum "Purchase Line Type";
    begin
        Rec.Type := PurchaseLineType::Item;
    end;

    trigger OnAfterGetCurrRecord()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        TotalQuantity := 0;
        LineQuantity := 0;
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."Document No.");
        if PurchaseLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + PurchaseLine.Quantity;
                LineQuantity := LineQuantity + 1;
            until PurchaseLine.Next() = 0;

    end;

    var
        Text001: Label 'Item %1 Variant Code %2 exists in the order';
        TotalQuantity: Decimal;
        LineQuantity: Integer;
}
