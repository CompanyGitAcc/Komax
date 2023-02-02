pageextension 59172 "TP Warehouse Pick" extends "Warehouse Pick"
{
    actions
    {
        addafter("&Print")
        {
            action("Print Pick")
            {
                Caption = 'Print Pick';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    PickingList: Report "Picking List 2";
                    WarehouseActivityHeader: Record "Warehouse Activity Header";
                    Item: Record Item;
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                begin
                    WarehouseActivityLine.Reset();
                    WarehouseActivityLine.SetRange("Activity Type", WarehouseActivityLine."Activity Type"::Pick);
                    WarehouseActivityLine.SetRange("No.", Rec."No.");
                    if WarehouseActivityLine.FindFirst() then
                        repeat
                            if Item.get(WarehouseActivityLine."Item No.") then begin
                                WarehouseActivityLine."Trolley No." := Item."Trolley No.";
                                WarehouseActivityLine.Modify();
                            end;
                        until WarehouseActivityLine.Next() = 0;
                    Commit();

                    WarehouseActivityHeader.SetRange(Type, Rec.Type::Pick);
                    WarehouseActivityHeader.SetRange("No.", Rec."No.");
                    PickingList.SetTableView(WarehouseActivityHeader);
                    PickingList.RunModal();
                end;
            }
            action("Print Barcode")
            {
                Caption = 'Print Barcode';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    QRCode: Report "QR Code";
                    WhseActivityHeader: Record "Warehouse Activity Header";
                begin
                    WhseActivityHeader.SetRange("No.", Rec."No.");
                    QRCode.SetTableView(WhseActivityHeader);
                    QRCode.RunModal();
                    Clear(QRCode);
                end;
            }


        }
    }



}
