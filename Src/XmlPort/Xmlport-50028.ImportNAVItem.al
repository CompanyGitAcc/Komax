xmlport 50028 "Import NAV Item"
{
    //改报表用于期初到库存
    Caption = 'Import NAV Item';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'ProductionBOMLine';
                AutoSave = false;
                textelement("G_No") { MinOccurs = Zero; }
                textelement("G_Description") { MinOccurs = Zero; }
                textelement("G_Description2") { MinOccurs = Zero; }
                textelement("G_BaseUnitofMeasure") { MinOccurs = Zero; }
                textelement("G_InventoryPostingGroup") { MinOccurs = Zero; }
                textelement("G_CostingMethod") { MinOccurs = Zero; }
                textelement("G_PriceIncludesVAT") { MinOccurs = Zero; }
                textelement("G_GenProdPostingGroup") { MinOccurs = Zero; }
                textelement("G_VATProdPostingGroup") { MinOccurs = Zero; }
                textelement("G_GlobalDimension2Code") { MinOccurs = Zero; }
                textelement("G_FlushingMethod") { MinOccurs = Zero; }
                textelement("G_ReplenishmentSystem") { MinOccurs = Zero; }
                textelement("G_RoundingPrecision") { MinOccurs = Zero; }
                textelement("G_IncludeInventory") { MinOccurs = Zero; }
                textelement("G_ManufacturingPolicy") { MinOccurs = Zero; }
                textelement("G_ManufacturerCode") { MinOccurs = Zero; }
                textelement("G_ItemCategoryCode") { MinOccurs = Zero; }
                textelement("G_ProductGroupCode") { MinOccurs = Zero; }
                textelement("G_ABC-Part") { MinOccurs = Zero; }
                textelement("G_ProductGroup") { MinOccurs = Zero; }
                textelement("G_RoutingNo.") { MinOccurs = Zero; }
                textelement("G_ProductionBOMNo") { MinOccurs = Zero; }
                textelement("G_QCCheckNeed") { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin

                end;

                trigger OnAfterInsertRecord()
                var
                    ProdGroupMapping: Record "Product Group Mapping";
                    InventoryGroupMapping: Record "Inventory Group Mapping";
                    UOM: Record "Unit of Measure";
                    ItemUOM: Record "Item Unit of Measure";
                begin
                    Window.UPDATE(1, G_No);
                    if G_No = '' then
                        exit;
                    IF Not G_Item.GET(G_No) THEN BEGIN
                        G_Item."No." := G_No;
                        G_item."Description" := G_Description;
                        G_item."Description 2" := G_Description2;
                        if GetUnitOfMeasere(G_BaseUnitofMeasure) = 'ERROR' then
                            G_item."Base Unit of Measure" := G_BaseUnitofMeasure
                        else
                            G_item."Base Unit of Measure" := GetUnitOfMeasere(G_BaseUnitofMeasure);
                        Evaluate(G_item."Costing Method", G_CostingMethod);
                        // ProdGroupMapping.Get(G_GenProdPostingGroup);
                        // InventoryGroupMapping.Get(G_InventoryPostingGroup);
                        G_Item."Old Gen. Prod. Posting Group" := G_GenProdPostingGroup;
                        g_item."Old Inventory Posting Group" := G_InventoryPostingGroup;

                        if ProdGroupMapping.Get(G_GenProdPostingGroup) then
                            G_item."Gen. Prod. Posting Group" := ProdGroupMapping."New Code"
                        else
                            G_item."Gen. Prod. Posting Group" := '';

                        if InventoryGroupMapping.Get(G_InventoryPostingGroup) then
                            G_item."Inventory Posting Group" := InventoryGroupMapping."New Code"
                        else
                            G_Item."Inventory Posting Group" := '';

                        IF COPYSTR(G_Item."No.", 1, 1) = 'T' THEN
                            G_Item."Global Dimension 2 Code" := 'WT'
                        else
                            G_Item."Global Dimension 2 Code" := 'WPM';

                        G_item."VAT Prod. Posting Group" := 'VAT13';
                        G_item."Global Dimension 2 Code" := G_GlobalDimension2Code;
                        Evaluate(G_item."Flushing Method", G_FlushingMethod);
                        Evaluate(G_item."Replenishment System", G_ReplenishmentSystem);
                        Evaluate(G_item."Rounding Precision", G_RoundingPrecision);
                        // Evaluate(G_item."Manufacturing Policy", G_ManufacturingPolicy);
                        G_item."Manufacturing Policy" := G_item."Manufacturing Policy"::"Make-to-Stock";
                        G_item."Item Category Code" := G_ItemCategoryCode;
                        G_item."ABC-Part" := "G_ABC-Part";
                        G_item."Product Group" := G_ProductGroup;
                        G_item."Routing No." := "G_RoutingNo.";
                        G_item."Production BOM No." := G_ProductionBOMNo;
                        Evaluate(G_item."QC Check Need", G_QCCheckNeed);

                        if UPPERCASE(CopyStr(G_item."No.", 1, 1)) = 'T' then begin
                            if UPPERCASE(G_item."Posting Group") = 'ZPTI' then begin
                                G_item."Routing No." := 'TSKTAB01';
                            end;

                            if (UPPERCASE(CopyStr(G_item."No.", StrLen(G_item."No."), 1)) <> 'R') and (UPPERCASE(CopyStr(G_item."Posting Group", 1, 4)) = 'ZMOD') then begin
                                G_item."Routing No." := 'TSKMUD02';
                            end;

                            if UPPERCASE(CopyStr(G_item."Posting Group", 1, 4)) = 'HALB' then begin
                                G_item."Routing No." := 'TSKPT01';
                            end;
                            if (UPPERCASE(CopyStr(G_item."No.", StrLen(G_item."No."), 1)) = 'R') and (UPPERCASE(CopyStr(G_item."Posting Group", 1, 4)) = 'ZMOD') then begin
                                G_item."Routing No." := 'REPAIR';
                            end;

                            if (UPPERCASE(G_item."Routing No.") = 'REPAIR') and (UPPERCASE(CopyStr(G_item."No.", StrLen(G_item."No."), 1)) = 'R') and (UPPERCASE(CopyStr(G_item."Posting Group", 1, 4)) = 'ZMOD') and (G_item."Production BOM No." <> '') then begin
                                G_item."Production BOM No." := '';
                            end;
                        end;

                        G_Item."Reordering Policy" := G_Item."Reordering Policy"::"Lot-for-Lot";
                        G_Item."Include Inventory" := true;
                        G_Item.Critical := true;
                        if (UPPERCASE(G_Item."Base Unit of Measure") <> 'MM') or (UPPERCASE(G_Item."Base Unit of Measure") <> 'M') then begin
                            G_Item."Rounding Precision" := 1;
                        end else
                            G_Item."Rounding Precision" := 0.001;
                        G_Item.INSERT;

                        if GetUnitOfMeasere(G_BaseUnitofMeasure) <> '' then begin
                            ItemUOM.Init();
                            ItemUOM."Item No." := G_Item."No.";
                            ItemUOM.Code := GetUnitOfMeasere(G_BaseUnitofMeasure);
                            ItemUOM.Validate("Qty. per Unit of Measure", 1);
                            if ItemUOM.Insert() then;
                        end else begin
                            Error(Text001, G_No);
                        end;
                    END else begin
                        if G_Item."Base Unit of Measure" in ['0', 'ST', '10', '11', '16', '19', '2', '20', '3', '4', '5', '7', '8', '12', '13', '15', 'BOX100', 'BOX1000', 'BOX1500', 'BOX200', 'BOX25', 'BOX250', 'BOX350', 'BOX50', 'BOX500', '', ' '] then begin
                            if ItemUOM.get(G_Item."No.", G_BaseUnitofMeasure) then
                                ItemUOM.Delete();

                            if GetUnitOfMeasere(G_BaseUnitofMeasure) <> '' then begin
                                ItemUOM.Init();
                                ItemUOM."Item No." := G_Item."No.";
                                ItemUOM.Code := GetUnitOfMeasere(G_BaseUnitofMeasure);
                                ItemUOM.Validate("Qty. per Unit of Measure", 1);
                                if ItemUOM.Insert() then;

                                G_item."Base Unit of Measure" := GetUnitOfMeasere(G_BaseUnitofMeasure);
                                G_Item.Modify();
                            end else begin
                                Error(Text001, G_No);
                            end;

                        end;
                    end;

                END;

            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        Window.OPEN('Item No.#1##################');
    end;

    trigger OnPostXmlPort()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        Window.Close();
        ItemUOM.Reset();
        ItemUOM.SetRange(Code, '');
        if ItemUOM.FindFirst() then
            ItemUOM.Delete();
    end;


    procedure GetUnitOfMeasere(P_Des: Code[10]) R_BUM: Code[10]
    begin
        R_BUM := '';
        IF UPPERCASE(P_Des) = '0' THEN
            R_BUM := 'PCS'
        ELSE
            IF UPPERCASE(P_Des) = 'ST' THEN
                R_BUM := 'PCS'
            ELSE
                IF UPPERCASE(P_Des) = '10' THEN
                    R_BUM := 'S'
                ELSE
                    IF UPPERCASE(P_Des) = '11' THEN
                        R_BUM := 'H'
                    ELSE
                        IF UPPERCASE(P_Des) = '16' THEN
                            R_BUM := 'R'
                        ELSE
                            IF UPPERCASE(P_Des) = '19' THEN
                                R_BUM := 'M2'
                            ELSE
                                IF UPPERCASE(P_Des) = '2' THEN
                                    R_BUM := 'M'
                                ELSE
                                    IF UPPERCASE(P_Des) = '20' THEN
                                        R_BUM := 'CM2'
                                    ELSE
                                        IF UPPERCASE(P_Des) = '3' THEN
                                            R_BUM := 'MM'
                                        ELSE
                                            IF UPPERCASE(P_Des) = '4' THEN
                                                R_BUM := 'KG'
                                            ELSE
                                                IF UPPERCASE(P_Des) = '5' THEN
                                                    R_BUM := 'G'
                                                ELSE
                                                    IF UPPERCASE(P_Des) = '7' THEN
                                                        R_BUM := 'L'
                                                    ELSE
                                                        IF UPPERCASE(P_Des) = '8' THEN
                                                            R_BUM := 'P'
                                                        ELSE
                                                            IF UPPERCASE(P_Des) = '12' THEN
                                                                R_BUM := 'PCS'
                                                            ELSE
                                                                IF UPPERCASE(P_Des) = '13' THEN
                                                                    R_BUM := 'PCS'
                                                                ELSE
                                                                    IF UPPERCASE(P_Des) = '15' THEN
                                                                        R_BUM := 'PCS'
                                                                    ELSE
                                                                        IF UPPERCASE(P_Des) = '14' THEN
                                                                            R_BUM := 'PCS'
                                                                        ELSE
                                                                            IF UPPERCASE(P_Des) = '17' THEN
                                                                                R_BUM := 'PCS'
                                                                            ELSE
                                                                                IF UPPERCASE(P_Des) = 'BOX100' THEN
                                                                                    R_BUM := 'BOX100'
                                                                                ELSE
                                                                                    IF UPPERCASE(P_Des) = 'BOX1000' THEN
                                                                                        R_BUM := 'BOX1000'
                                                                                    ELSE
                                                                                        IF UPPERCASE(P_Des) = 'BOX1500' THEN
                                                                                            R_BUM := 'BOX1500'
                                                                                        ELSE
                                                                                            IF UPPERCASE(P_Des) = 'BOX200' THEN
                                                                                                R_BUM := 'BOX200'
                                                                                            ELSE
                                                                                                IF UPPERCASE(P_Des) = 'BOX25' THEN
                                                                                                    R_BUM := 'BOX25'
                                                                                                ELSE
                                                                                                    IF UPPERCASE(P_Des) = 'BOX250' THEN
                                                                                                        R_BUM := 'BOX250'
                                                                                                    ELSE
                                                                                                        IF UPPERCASE(P_Des) = 'BOX350' THEN
                                                                                                            R_BUM := 'BOX350'
                                                                                                        ELSE
                                                                                                            IF UPPERCASE(P_Des) = 'BOX50' THEN
                                                                                                                R_BUM := 'BOX50'
                                                                                                            ELSE
                                                                                                                IF UPPERCASE(P_Des) = 'BOX500' THEN
                                                                                                                    R_BUM := 'BOX500'
                                                                                                                ELSE
                                                                                                                    IF P_Des = '' THEN
                                                                                                                        R_BUM := 'MM2'
                                                                                                                    ELSE
                                                                                                                        R_BUM := 'ERROR';
    end;


    var
        Window: Dialog;
        G_Item: Record Item;
        Text001: Label 'Unit of measure cannot be empty,No.:%1';

}
