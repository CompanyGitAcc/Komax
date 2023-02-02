pageextension 59102 "TP Item Journal" extends "Item Journal"
{
    layout
    {
        addafter("Location Code")
        {
            field("Location Name"; Rec."Location Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Bin Code")
        {
            Visible = true;
        }

        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }

        movelast(Control1; "Applies-to Entry")

        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
                BinContent: Record "Bin Content";
            begin
                IF Item.Get(Rec."Item No.") then begin
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", Item."No.");
                    BinContent.SetRange("Location Code", Rec."Location Code");
                    BinContent.SetRange(Default, true);
                    if BinContent.FindFirst() then
                        Rec."Bin Code" := BinContent."Bin Code";
                end;
            end;
        }

        addlast(Control1)
        {
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
            field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
            {
                ApplicationArea = all;
            }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = all;
            }
            field("Komax Reason Code"; Rec."Komax Reason Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            //期初
            // action("Get Openning Shipment")
            // {
            //     Caption = 'Get Openning Shipment';
            //     Image = Refresh;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Visible = false;

            //     trigger OnAction()
            //     var
            //         SalesLine: Record "Sales Line";
            //         ItemJournalLine: Record "Item Journal Line";
            //         LastLineNo: Integer;
            //         ItemJournalLine2: Record "Item Journal Line";
            //         Item: Record Item;
            //         Itemblocked: Boolean;
            //         Window: Dialog;
            //     begin
            //         Window.Open('Process #1#############');
            //         Rec.TestField("Journal Template Name");
            //         Rec.TestField("Journal Batch Name");
            //         ItemJournalLine2.Reset();
            //         ItemJournalLine2.SetRange("Journal Template Name", Rec."Journal Template Name");
            //         ItemJournalLine2.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            //         if ItemJournalLine2.FindLast() THEN
            //             LastLineNo := ItemJournalLine2."Line No.";

            //         LastLineNo += 10000;
            //         //unblock item
            //         SalesLine.Reset();
            //         SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            //         if SalesLine.FindFirst() then
            //             repeat
            //                 Window.Update(1, SalesLine."Document No.");
            //                 if Item.get(SalesLine."No.") then begin
            //                     if Item.Blocked = true then begin
            //                         Itemblocked := true;
            //                         Item.Blocked := false;
            //                         Item.Modify();
            //                     end;
            //                 end;
            //                 SalesLine.Modify();
            //             until SalesLine.Next() = 0;

            //         SalesLine.Reset();
            //         SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
            //         SalesLine.SetFilter("Post Qty", '>%1', 0); // Quantity shipped not invoiced
            //         if SalesLine.FindFirst() then
            //             repeat
            //                 Window.Update(1, SalesLine."Document No.");
            //                 ItemJournalLine.Init();
            //                 ItemJournalLine."Journal Template Name" := Rec."Journal Template Name";
            //                 ItemJournalLine."Journal Batch Name" := Rec."Journal Batch Name";
            //                 ItemJournalLine."Line No." := LastLineNo;

            //                 ItemJournalLine.Validate("Item No.", SalesLine."No.");
            //                 ItemJournalLine.Validate("Posting Date", 20221231D); // hard code for posting date
            //                 ItemJournalLine.Validate(Quantity, SalesLine."Post Qty");
            //                 ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::"Positive Adjmt.");
            //                 ItemJournalLine.Validate("Document No.", 'OPEN02');// hard code
            //                 ItemJournalLine.Validate("Location Code", SalesLine."Location Code");
            //                 ItemJournalLine.Validate("Bin Code", 'OPEN');// hard code

            //                 ItemJournalLine.INSERT(TRUE);
            //                 LastLineNo += 10000;
            //                 if ItemJournalLine."Unit Amount" <> 0 then begin
            //                     SalesLine."Unit Cost (LCY)" := ItemJournalLine."Unit Amount";
            //                     SalesLine.Modify();
            //                 end else begin
            //                     ItemJournalLine.Validate("Unit Amount", SalesLine."Unit Cost (LCY)");
            //                     ItemJournalLine.Modify();
            //                 end;

            //             until SalesLine.Next() = 0;
            //         Window.Close();
            //     end;
            // }
        }
    }

}
