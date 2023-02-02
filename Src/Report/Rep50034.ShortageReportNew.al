report 50034 "Shortage Report New"
{
    WordLayout = './Layout/ShortageReport.docx';
    Caption = 'Shortage Report';
    DefaultLayout = Word;
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            RequestFilterFields = "No.";
            column(Status; Status)
            {
            }
            column(No_; "No.")
            {
            }
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                column(Prod_Order_Status; Status)
                {
                }
                column(Prod__Order_No_; "Prod. Order No.")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                IF Transfer_ProdOrder <> '' THEN
                    "Production Order".SETFILTER("Production Order"."No.", Transfer_ProdOrder)
                ELSE
                    "Production Order".SETFILTER("Production Order"."No.", "Production Order".GETFILTER("Production Order"."No."));
            end;


        }
        dataitem("Shortage Item"; "Shortage Item")
        {
            column(Shortage_Item_No_; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(Need_Qty; "Need Qty")
            {
            }
            column(BinInventory; BinInventory)
            {
            }
            column(Shortage_Qty; "Shortage Qty")
            {
            }
            column(Purch_Qty; "Purch Qty")
            {
            }
            column(ABC_Parts; "ABC Parts")
            {
            }
            column(Flushing_Method; "Flushing Method")
            {
            }
        }

    }
    trigger OnInitReport()
    begin
        Transfer_WIP := FALSE;
        Transfer_RAW := FALSE;
        Transfer_Purchase := FALSE;
    end;

    trigger OnPreReport()
    begin

        CalcateAllCompoent;
        IF ExportToExcel = TRUE THEN BEGIN
            TempExcelBuffer.RESET;
            TempExcelBuffer.DELETEALL;
        END;
        RowNo := 0;
        Gtxt_ShowHeader := '';
        Gtxt_ShowHeader2 := '';
        Gtxt_SHowHeader3 := '';
        IF Transfer_WIP AND Transfer_RAW THEN BEGIN
            Gtxt_ShowHeader := 'Consumption Bin : Production Inventory ';
        END
        ELSE
            IF Transfer_WIP AND (NOT Transfer_RAW) THEN BEGIN
                Gtxt_ShowHeader := 'Consumption Bin : WIP/PRODINBOUND';
            END
            ELSE
                IF (NOT Transfer_WIP) AND Transfer_RAW THEN BEGIN
                    Gtxt_ShowHeader := 'Consumption Bin : Production Inventory ';
                END
                ELSE
                    Gtxt_ShowHeader := 'Error Bin information!';

        IF Transfer_Purchase THEN
            Gtxt_ShowHeader2 := 'Inventory include Purchase Order';

        IF Transfer_ProdOrder <> '' THEN
            Gtxt_SHowHeader3 := Transfer_ProdOrder;
    end;

    trigger OnPostReport()
    var
        RemainQty: Decimal;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.get();
        ManufacturingSetup.TestField("Default Movement Worksheet");
        ManufacturingSetup.TestField("Production Location");
        IF Transfer_Cparts = TRUE THEN BEGIN
            WindowCreateC.OPEN('Movement Shortage #1####################\' +
                               'Item No.          #2####################');
            Gint_Line := 0;
            Grcd_ShorageItem.RESET;
            Grcd_ShorageItem.SETFILTER(Grcd_ShorageItem."Shortage Qty", '>%1', 0);
            //Grcd_ShorageItem.SETRANGE(Grcd_ShorageItem."ABC Parts",'C');
            Grcd_ShorageItem.SETRANGE(Grcd_ShorageItem."Flushing Method", Grcd_ShorageItem."Flushing Method"::Backward);
            IF Grcd_ShorageItem.FIND('-') THEN BEGIN
                IF (Transfer_WIP = TRUE) AND (Transfer_RAW = FALSE) THEN BEGIN
                    Grcd_WhseWorkLine.RESET;
                    Grcd_WhseWorkLine.SETRANGE(Grcd_WhseWorkLine."Worksheet Template Name", 'MOVEMENT');
                    Grcd_WhseWorkLine.SETRANGE(Grcd_WhseWorkLine.Name, ManufacturingSetup."Default Movement Worksheet");
                    Grcd_WhseWorkLine.SETRANGE(Grcd_WhseWorkLine."Location Code", ManufacturingSetup."Production Location");
                    Grcd_WhseWorkLine.SETFILTER("Line No.", '>%1', 0);
                    IF Grcd_WhseWorkLine.FIND('-') THEN BEGIN
                        MESSAGE('Movement Create Failed! Because Movement Template Name:MOVEMENT, Name: SHORTAGE has exist!');
                    END
                    ELSE BEGIN
                        Grcd_ShorageItem2.RESET;
                        Grcd_ShorageItem2.SETFILTER(Grcd_ShorageItem2."Shortage Qty", '>%1', 0);
                        Grcd_ShorageItem2.SETRANGE(Grcd_ShorageItem2."Flushing Method", Grcd_ShorageItem2."Flushing Method"::Backward);
                        //Grcd_ShorageItem2.SETRANGE(Grcd_ShorageItem2."ABC Parts",'C');
                        IF Grcd_ShorageItem2.FIND('-') THEN
                            REPEAT
                                WindowCreateC.UPDATE(1, 'Movement Creating');
                                WindowCreateC.UPDATE(2, Grcd_ShorageItem2."No.");
                                Grcd_BinContent2.RESET;
                                //TECCN_AS -->
                                Grcd_BinContent2.SETRANGE("Location Code", Grcd_ManufacturSetup."Production Location");
                                Grcd_BinContent2.SETRANGE(Grcd_BinContent2."Bin Type Code", 'PUTPICK');
                                //TECCN_AS <--
                                //Grcd_BinContent2.SETRANGE("Bin Code",'RAW MATERIAL');
                                Grcd_BinContent2.SETRANGE("Item No.", Grcd_ShorageItem2."No.");
                                //Grcd_BinContent2.SETFILTER(Quantity,'>=%1',Grcd_ShorageItem2."Shortage Qty");
                                Grcd_BinContent2.SETFILTER(Quantity, '>0');
                                RemainQty := Grcd_ShorageItem2."Shortage Qty";

                                IF Grcd_BinContent2.FIND('-') THEN
                                    REPEAT
                                        Grcd_BinContent2.CALCFIELDS(Quantity);
                                        Gint_Line += 10000;
                                        Grcd_WhseWorkLine.INIT;
                                        Grcd_WhseWorkLine."Worksheet Template Name" := 'MOVEMENT';
                                        Grcd_WhseWorkLine.Name := ManufacturingSetup."Default Movement Worksheet";
                                        Grcd_WhseWorkLine."Location Code" := Grcd_ManufacturSetup."Production Location";
                                        Grcd_WhseWorkLine."Line No." := Gint_Line;
                                        Grcd_WhseWorkLine."Item No." := Grcd_ShorageItem2."No.";
                                        Grcd_WhseWorkLine.VALIDATE(Grcd_WhseWorkLine."Item No.", Grcd_ShorageItem2."No.");
                                        Grcd_WhseWorkLine."From Bin Code" := Grcd_BinContent2."Bin Code";
                                        Grcd_WhseWorkLine.VALIDATE(Grcd_WhseWorkLine."From Bin Code");
                                        Grcd_WhseWorkLine."To Bin Code" := 'WIP';
                                        Grcd_WhseWorkLine.VALIDATE(Grcd_WhseWorkLine."To Bin Code");
                                        IF RemainQty <= Grcd_BinContent2.Quantity THEN BEGIN
                                            Grcd_WhseWorkLine.Quantity := RemainQty;
                                            RemainQty := RemainQty - RemainQty;
                                        END ELSE BEGIN
                                            Grcd_WhseWorkLine.Quantity := Grcd_BinContent2.Quantity;
                                            RemainQty := RemainQty - Grcd_BinContent2.Quantity;
                                        END;
                                        Grcd_WhseWorkLine.VALIDATE(Grcd_WhseWorkLine.Quantity);
                                        Grcd_WhseWorkLine.INSERT;

                                    UNTIL (Grcd_BinContent2.NEXT = 0) OR (RemainQty <= 0);
                            UNTIL Grcd_ShorageItem2.NEXT = 0;
                    END;
                END;
            END;
            WindowCreateC.CLOSE;
            MESSAGE('Shortage Movement has been created!');
        END;

    end;

    procedure CalcateAllCompoent()
    begin

        Window.OPEN('Production Order #1##############\' +
                    'Compoent Item    #2##############');
        Temp_ProdCompoent.RESET;
        Temp_ProdCompoent.DELETEALL;
        Grcd_ShortItem.RESET;
        Grcd_ShortItem.DELETEALL;

        Grcd_ProductionOrder.RESET;
        IF Transfer_ProdOrder <> '' THEN
            Grcd_ProductionOrder.SETFILTER(Grcd_ProductionOrder."No.", Transfer_ProdOrder)
        ELSE
            Grcd_ProductionOrder.SETFILTER(Grcd_ProductionOrder."No.", "Production Order".GETFILTER("Production Order"."No."));
        IF Grcd_ProductionOrder.FIND('-') THEN
            REPEAT
                Grcd_ProdOrderLine.RESET;
                Grcd_ProdOrderLine.SETCURRENTKEY(Status, "Prod. Order No.", "Line No.");
                Grcd_ProdOrderLine.SETRANGE(Status, Grcd_ProductionOrder.Status);
                Grcd_ProdOrderLine.SETRANGE("Prod. Order No.", Grcd_ProductionOrder."No.");
                IF Grcd_ProdOrderLine.FIND('-') THEN
                    REPEAT
                        Grcd_ProdCompoent.RESET;
                        Grcd_ProdCompoent.SETCURRENTKEY(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.");
                        Grcd_ProdCompoent.SETRANGE(Status, Grcd_ProdOrderLine.Status);
                        Grcd_ProdCompoent.SETRANGE("Prod. Order No.", Grcd_ProdOrderLine."Prod. Order No.");
                        Grcd_ProdCompoent.SETRANGE("Prod. Order Line No.", Grcd_ProdOrderLine."Line No.");
                        IF Grcd_ProdCompoent.FIND('-') THEN
                            REPEAT
                                Window.UPDATE(1, Grcd_ProductionOrder."No.");
                                Window.UPDATE(2, Grcd_ProdCompoent."Item No.");
                                Grcd_ShortItem.RESET;
                                Grcd_ShortItem.SETRANGE(Grcd_ShortItem."No.", Grcd_ProdCompoent."Item No.");
                                IF Grcd_ShortItem.FIND('-') THEN BEGIN
                                    Grcd_ShortItem."Need Qty" += Grcd_ProdCompoent.Quantity * Grcd_ProdOrderLine.Quantity;
                                    // Grcd_ShortItem."Shortage Qty" += Grcd_ProdCompoent.Quantity * Grcd_ProdOrderLine.Quantity;
                                    IF Transfer_Purchase = TRUE THEN
                                        Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Grcd_ShortItem."Purch Qty"
                                          - Gdec_ProductionInv
                                    ELSE BEGIN
                                        IF Transfer_RAW = TRUE THEN
                                            Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Grcd_ShortItem.Inventory
                                        ELSE
                                            Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Grcd_ShortItem.BinInventory
                                    END;
                                    IF Grcd_ShortItem."Shortage Qty" < 0 THEN
                                        Grcd_ShortItem."Shortage Qty" := 0;

                                    Grcd_ShortItem.MODIFY;
                                END
                                ELSE BEGIN
                                    Grcd_Item.RESET;
                                    Grcd_Item.GET(Grcd_ProdCompoent."Item No.");
                                    //Grcd_Item.SETRANGE(Grcd_Item."Location Filter",Grcd_ManufacturSetup."Production Location");
                                    //--------- Calcuate Consumption Bin Qty
                                    Gdec_BinManufcQty := 0;
                                    Gdec_ProductionInv := 0;
                                    Grcd_ManufacturSetup.RESET;
                                    IF Grcd_ManufacturSetup.GET() THEN BEGIN
                                        Grcd_ManufacturSetup.TESTFIELD(Grcd_ManufacturSetup."Production Location");
                                        Grcd_Location.GET(Grcd_ManufacturSetup."Production Location");
                                        //IF Transfer_WIP = TRUE THEN BEGIN
                                        Grcd_BinContent.RESET;
                                        Grcd_BinContent.SETRANGE("Location Code", Grcd_ManufacturSetup."Production Location");
                                        CASE Grcd_Item."Flushing Method" OF
                                            Grcd_Item."Flushing Method"::Backward:
                                                Grcd_BinContent.SETRANGE("Bin Code", Grcd_Location."Open Shop Floor Bin Code");
                                            ELSE
                                                Grcd_BinContent.SETRANGE("Bin Code", Grcd_Location."Inbound Production Bin Code");
                                        END;

                                        //Grcd_BinContent.SETRANGE("Bin Code",Grcd_ManufacturSetup."Production Bin1");
                                        Grcd_BinContent.SETRANGE(Grcd_BinContent."Bin Type Code", 'PUTPICK');
                                        Grcd_BinContent.SETRANGE("Item No.", Grcd_ProdCompoent."Item No.");
                                        IF Grcd_BinContent.FIND('-') THEN
                                            REPEAT
                                                Grcd_BinContent.CALCFIELDS(Grcd_BinContent.Quantity);
                                                Gdec_BinManufcQty += Grcd_BinContent.Quantity;
                                            UNTIL Grcd_BinContent.NEXT = 0;
                                        //END;
                                        //IF Transfer_RAW = TRUE THEN BEGIN
                                        Grcd_BinContent.RESET;
                                        Grcd_BinContent.SETRANGE("Location Code", Grcd_ManufacturSetup."Production Location");
                                        Grcd_BinContent.SETRANGE(Grcd_BinContent."Bin Type Code", 'PUTPICK');
                                        //Grcd_BinContent.SETFILTER("Bin Code",'<>%1',Grcd_ManufacturSetup."Production Bin1");
                                        Grcd_BinContent.SETRANGE("Item No.", Grcd_ProdCompoent."Item No.");
                                        IF Grcd_BinContent.FIND('-') THEN
                                            REPEAT
                                                Grcd_BinContent.CALCFIELDS(Grcd_BinContent.Quantity);
                                                Gdec_ProductionInv += Grcd_BinContent.Quantity;
                                            UNTIL Grcd_BinContent.NEXT = 0;
                                        //END;
                                    END;
                                    //+++++++++
                                    Grcd_Item.CALCFIELDS(Grcd_Item.Inventory, Grcd_Item."Qty. on Purch. Order");
                                    Grcd_ShortItem.INIT;
                                    Grcd_ShortItem."No." := Grcd_ProdCompoent."Item No.";
                                    Grcd_ShortItem.Description := Grcd_ProdCompoent.Description;
                                    //Grcd_ShortItem.Inventory := Grcd_Item.Inventory;
                                    Grcd_ShortItem.Inventory := Gdec_ProductionInv;
                                    Grcd_ShortItem."Need Qty" := Grcd_ProdCompoent.Quantity * Grcd_ProdOrderLine.Quantity;
                                    Grcd_ShortItem.BinInventory := Gdec_BinManufcQty;
                                    Grcd_ShortItem."Purch Qty" := Grcd_Item."Qty. on Purch. Order";
                                    IF Transfer_Purchase = TRUE THEN
                                        Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Grcd_ShortItem."Purch Qty"
                                          - Gdec_ProductionInv
                                    ELSE BEGIN
                                        IF Transfer_RAW = TRUE THEN
                                            Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Gdec_ProductionInv
                                        ELSE
                                            Grcd_ShortItem."Shortage Qty" := Grcd_ShortItem."Need Qty" - Gdec_BinManufcQty
                                    END;
                                    IF Grcd_ShortItem."Shortage Qty" < 0 THEN
                                        Grcd_ShortItem."Shortage Qty" := 0;
                                    Grcd_ShortItem."ABC Parts" := Grcd_Item."ABC-Part";
                                    Grcd_ShortItem."Flushing Method" := Grcd_ProdCompoent."Flushing Method";
                                    Grcd_ShortItem.INSERT;
                                END;
                            UNTIL Grcd_ProdCompoent.NEXT = 0;
                    UNTIL Grcd_ProdOrderLine.NEXT = 0;
            UNTIL Grcd_ProductionOrder.NEXT = 0;
        COMMIT;
        Window.CLOSE;
    end;

    procedure TransferProdOrder(P_ProdOrder: Text[200])
    begin
        Transfer_ProdOrder := P_ProdOrder;
    end;

    procedure TransferBinPurchseFalg(P_WIP: Boolean; P_RAW: Boolean; P_Purchase: Boolean; P_Cparts: Boolean)
    begin
        Transfer_WIP := P_WIP;
        Transfer_RAW := P_RAW;
        Transfer_Purchase := P_Purchase;
        Transfer_Cparts := P_Cparts;
    end;

    procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; Italic: Boolean; UnderLine: Boolean)
    begin
        TempExcelBuffer.INIT;
        TempExcelBuffer.VALIDATE("Row No.", RowNo);
        TempExcelBuffer.VALIDATE("Column No.", ColumnNo);
        TempExcelBuffer."Cell Value as Text" := CellValue;
        TempExcelBuffer.Formula := '';
        TempExcelBuffer.Bold := Bold;
        TempExcelBuffer.Italic := Italic;
        TempExcelBuffer.Underline := UnderLine;
        TempExcelBuffer.INSERT;
    end;

    var
        Window: Dialog;
        WindowCreateC: Dialog;
        Temp_ProdCompoent: Record "Prod. Order Component" TEMPORARY;
        Grcd_ProductionOrder: Record "Production Order";
        Grcd_ProdOrderLine: Record "Prod. Order Line";
        Grcd_ProdCompoent: Record "Prod. Order Component";
        Grcd_ShortItem: Record "Shortage Item";
        Grcd_Item: Record "Item";
        Grcd_BinContent: Record "Bin Content";
        Grcd_ManufacturSetup: Record "Manufacturing Setup";
        Transfer_ProdOrder: Text[200];
        Transfer_WIP: Boolean;
        Transfer_RAW: Boolean;
        Transfer_Purchase: Boolean;
        Transfer_Cparts: Boolean;
        Gtxt_ShowHeader: Text[200];
        Gtxt_ShowHeader2: Text[200];
        Gtxt_SHowHeader3: Text[1000];
        Gdec_BinManufcQty: Decimal;
        Gdec_Inventroy: Decimal;
        Gdec_NeedQty: Decimal;
        Gdec_BinInventory: Decimal;
        Gdec_ShortQty: Decimal;
        Gdec_PurchQty: Decimal;
        Gtxt_ABC: Code[20];
        ExportToExcel: Boolean;
        TempExcelBuffer: Record "Excel Buffer";
        RowNo: Integer;
        MakeOrBuy: Text[30];
        Item: Record "Item";
        "#Following Var are used for Mo": Integer;
        Grcd_WhseWorkLine: Record "Whse. Worksheet Line";
        Grcd_ShorageItem: Record "Shortage Item";
        Grcd_ShorageItem2: Record "Shortage Item";
        Grcd_BinContent2: Record "Bin Content";
        Gint_Line: Integer;
        Gdec_ProductionInv: Decimal;
        Grcd_Location: Record Location;


}


