pageextension 59010 "TP Item List" extends "Item List"
{
    layout
    {
        modify("Assembly BOM")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }

        modify("Item Category Code")
        {
            Visible = true;
        }
        addafter("Item Category Code")
        {
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
        }
        modify("Sales Unit of Measure")
        {
            Visible = true;
        }
        modify("Purch. Unit of Measure")
        {
            Visible = true;
        }

        modify("Gen. Prod. Posting Group") { Visible = true; }
        modify("Inventory Posting Group") { Visible = true; }
        addafter("Inventory Posting Group")
        {
            field("Posting Group"; Rec."Posting Group") //该字段由PLM接口导入
            {
                ApplicationArea = all;
            }
        }
        // addafter("Gen. Prod. Posting Group")
        // {
        //     field("Old Gen. Prod. Posting Group"; Rec."Old Gen. Prod. Posting Group")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        // addafter("Inventory Posting Group")
        // {
        //     field("Old Inventory Posting Group"; Rec."Old Inventory Posting Group")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        addlast(Control1)
        {
            field("Part status"; Rec."Part status")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 5 Code"; Rec."Global Dimension 5 Code")
            {
                ApplicationArea = all;
            }
            field("ABC-Part"; Rec."ABC-Part")
            {
                ApplicationArea = all;
            }
            field("PLM Import Flag"; Rec."PLM Import Flag")
            {
                ApplicationArea = all;
            }
            field("Put-away Unit of Measure Code"; Rec."Put-away Unit of Measure Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Flushing Method")
        {
            Visible = true;
        }
        modify("Last Date Modified")
        {
            Visible = true;
        }
        modify("Vendor Item No.")
        {
            Visible = true;
        }
        moveafter("No."; "Vendor Item No.")
        moveafter("Description 2"; "Vendor No.")
        addafter(InventoryField)
        {
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = all;
            }
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = all;
            }
            field("Product Group"; Rec."Product Group")
            {
                ApplicationArea = all;
            }
            field("Reorder Point"; Rec."Reorder Point")
            {
                ApplicationArea = all;
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
        }
    }

    actions
    {
        addlast(Item)
        {
            // action("Refresh Flush Method")
            // {
            //     Caption = 'Refresh Flush Method';
            //     Promoted = true;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         RefreshFlushMethod: Report "Refresh Flush Method";
            //     begin
            //         RefreshFlushMethod.RunModal();
            //     end;
            // }

            action("Import PLM Item")
            {
                Caption = 'Import PLM Item';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLFileUserImportL: XMLport "Import PLM Item";
                begin
                    XMLFileUserImportL.Run;
                    // UpdatePage();
                end;
            }
            action("Import NAV Item")
            {
                Caption = 'Import NAV Item';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLFileUserImportL: XMLport "Import NAV Item";
                begin
                    XMLFileUserImportL.Run;
                end;
            }

            action("Import Item Vendor")
            {
                Caption = 'Import Item Vendor';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLFileUserImportL: XMLport "Import Item Vendor";
                begin
                    XMLFileUserImportL.Run;
                end;
            }

            action("Import Drawing Infomation")
            {
                Caption = 'Import Drawing Infomation';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLFileUserImportL: XMLport "Drawing Infomation";
                begin
                    XMLFileUserImportL.Run;
                    // UpdatePage();
                end;
            }
            action("Refresh Rounting No.")
            {
                Caption = 'Refresh T-Rounting No.';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    window: Dialog;
                    Item: Record Item;
                begin
                    window.Open('#1###########');
                    Item.Reset();
                    Item.SetFilter("No.", 'T*');

                    if Item.FindFirst() then
                        repeat
                            window.Update(1, Item."No.");
                            //if Item."Routing No." = '' then begin
                            if UPPERCASE(CopyStr(Item."No.", 1, 1)) = 'T' then begin
                                if UPPERCASE(Item."Posting Group") = 'ZPTI' then begin
                                    Item."Routing No." := 'TSKTAB01';
                                end;

                                if (UPPERCASE(CopyStr(Item."No.", StrLen(Item."No."), 1)) <> 'R') and (UPPERCASE(CopyStr(Item."Posting Group", 1, 4)) = 'ZMOD') then begin
                                    Item."Routing No." := 'TSKMUD02';
                                end;

                                if UPPERCASE(CopyStr(Item."Posting Group", 1, 4)) = 'HALB' then begin
                                    Item."Routing No." := 'TSKPT01';
                                end;
                            end;

                            if (UPPERCASE(CopyStr(Item."No.", StrLen(Item."No."), 1)) = 'R') and (UPPERCASE(CopyStr(Item."Posting Group", 1, 4)) = 'ZMOD') then begin
                                Item."Routing No." := 'REPAIR';
                            end;

                            if (UPPERCASE(Item."Routing No.") = 'REPAIR') and (UPPERCASE(CopyStr(Item."No.", StrLen(Item."No."), 1)) = 'R') and (UPPERCASE(CopyStr(Item."Posting Group", 1, 4)) = 'ZMOD') and (Item."Production BOM No." <> '') then begin
                                Item."Production BOM No." := '';
                            end;

                            Item.Modify();
                        until Item.Next() = 0;
                    window.Close();
                end;
            }

            action("Refresh Item Sales/Purchase UOM")
            {
                Caption = 'Refresh Item Sales/Purchase UOM';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Item: Record Item;
                    Window: Dialog;
                begin
                    Window.OPEN('Item No.#1##################');
                    Item.Reset();
                    if Item.FindFirst() then
                        repeat
                            Window.Update(1, Item."No.");
                            if Item."Base Unit of Measure" <> Item."Sales Unit of Measure" then begin
                                Item."Sales Unit of Measure" := Item."Base Unit of Measure";
                                Item."Purch. Unit of Measure" := Item."Base Unit of Measure";
                                Item.Modify();
                            end;
                        until Item.Next() = 0;
                    Window.Close();
                end;
            }

            action("Refresh Prod. Dim")
            {
                Caption = 'Refresh Prod. Dim';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Item: Record Item;
                    Window: Dialog;
                begin
                    Window.OPEN('Item No.#1##################');
                    Item.Reset();
                    if Item.FindFirst() then
                        repeat
                            Window.Update(1, Item."No.");
                            if CopyStr(Item."No.", 1, 1) = 'T' then
                                Item.Validate("Global Dimension 2 Code", 'WT')
                            else
                                item.Validate("Global Dimension 2 Code", 'WPM');
                            Item.Modify();
                        until Item.Next() = 0;
                    Window.Close();
                end;
            }
        }
    }
}
