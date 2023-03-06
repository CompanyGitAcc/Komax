xmlport 50027 "Import PLM Item"
{
    Caption = 'Import PLM Item';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    Format = VariableText;
    FormatEvaluate = Legacy;
    //TextEncoding = WINDOWS;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(Item; Item)
            {
                XmlName = 'ProductionBOMLine';
                AutoSave = false;
                textelement(I_Articel_No)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Name_Desc)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Name2_Desc2)
                {
                    MinOccurs = Zero;
                }
                textelement(I_QuantityUnit_BUM)
                {
                    MinOccurs = Zero;
                }
                //NO USE(I_Sare_ServiceItemGroup)
                textelement(EXT1)
                {
                    MinOccurs = Zero;
                }

                textelement(I_BOMLines_RepSystem_BOM)
                {
                    MinOccurs = Zero;
                }
                //I_Alternative_AlternPart
                textelement(EXT2)
                {
                    MinOccurs = Zero;
                }
                //零件状态 I_Code_Level_State
                textelement(I_SML3)
                {
                    MinOccurs = Zero;
                }
                //过账组
                textelement(I_SML1)
                {
                    MinOccurs = Zero;
                }
                // textelement(I_SML2)
                // {
                //     MinOccurs = Zero;
                // }
                textelement(EXT3)
                {
                    MinOccurs = Zero;
                }
                textelement(EXT4)
                {
                    MinOccurs = Zero;
                }
                textelement(EXT5)
                {
                    MinOccurs = Zero;
                }
                textelement(EXT6)
                {
                    MinOccurs = Zero;
                }
                textelement(EXT7)
                {
                    MinOccurs = Zero;
                }

                //时间字段Last Date Modified
                textelement(I_SML4)
                {
                    MinOccurs = Zero;

                }
                textelement(BrandCode)
                {
                    MinOccurs = Zero;
                }
                textelement(EXt8)
                {
                    MinOccurs = Zero;
                }
                textelement(EXt9)
                {
                    MinOccurs = Zero;
                }
                textelement(I_ABC)
                {
                    MinOccurs = Zero;
                }
                textelement(FlushingMethod)
                {
                    MinOccurs = Zero;
                }
                // fieldelement(FlushingMethod; Item."Flushing Method")
                // {
                //     MinOccurs = Zero;
                // }
                // textelement(I_CommonItemNo)
                // {
                //     MinOccurs = Zero;
                // }
                trigger OnBeforeInsertRecord()
                begin

                end;

                trigger OnAfterInsertRecord()
                begin
                    Window.UPDATE(1, I_Articel_No);
                    Gcde_InvePostGroup := '';
                    Gcde_GenPostGroup := '';
                    Gbol_BaseError := FALSE;
                    Gbol_BaseDiff := FALSE;
                    Gbol_SparePartDiff := FALSE;
                    Gbol_ReplishDiff := FALSE;
                    Gbol_NoABC := FALSE;
                    Gbol_NewItem := FALSE;
                    Gbol_PostingGroup := FALSE;
                    Yesterday := CalcDate('-1D', WorkDate());
                    ToDay := WorkDate();
                    //Initing Import Var Value----
                    if I_SML4 = '' then begin
                        Error(Text001, I_Articel_No);
                    end;
                    D := ConvertDate(I_SML4);
                    ConvertUOM(Gcde_BUMCode, RoundingPrecision);
                    Gcde_FirstLetter := UPPERCASE(COPYSTR(I_SML1, 1, 1));
                    Gcde_InvePostGroup := '';
                    IF NOT (Gcde_FirstLetter IN ['A' .. 'Z']) THEN
                        Gcde_FirstLetter := UPPERCASE(COPYSTR(I_SML1, 1, 2));
                    //BreakLoop := FALSE;
                    //handle Posting Groups
                    IF Grcd_InvPostingGroup.GET(I_SML1) THEN BEGIN
                        Gcde_InvePostGroup := I_SML1;
                        //BreakLoop := TRUE;
                    END ELSE
                        if InventoryGroupMapping.get(I_SML1) then begin
                            Gcde_InvePostGroup := InventoryGroupMapping."New Code";
                            //BreakLoop := TRUE;
                        end;

                    //BreakLoop1 := FALSE;
                    Gcde_GenPostGroup := '';
                    IF Grcd_GenProPostingGroup.GET(I_SML1) THEN BEGIN
                        Gcde_GenPostGroup := I_SML1;
                        //BreakLoop1 := TRUE;
                    END ELSE
                        if ProductGroupMapping.get(I_SML1) then begin
                            Gcde_GenPostGroup := ProductGroupMapping."New Code";
                            //BreakLoop1 := TRUE;
                        end;

                    //Import Or Replace Item------错误的记录跳过继续下一条
                    //Grcd_ItemImport.RESET;
                    // IF Grcd_ItemImport.GET(I_Articel_No) and (D >= Yesterday) and (ToDay >= D) THEN BEGIN
                    IF Grcd_ItemImport.GET(I_Articel_No) THEN BEGIN
                        Grcd_ItemImport.Description := I_Name_Desc;
                        IF Gcde_BUMCode <> Grcd_ItemImport."Base Unit of Measure" THEN
                            Gbol_BaseDiff := TRUE;
                        //<< Validate Begin
                        IF (Gcde_BUMCode <> '') THEN BEGIN
                            IF NOT ItemUnitOfMeasure.GET(I_Articel_No, Gcde_BUMCode) THEN BEGIN
                                ItemUnitOfMeasure.INIT;
                                ItemUnitOfMeasure."Item No." := I_Articel_No;
                                ItemUnitOfMeasure.Code := Gcde_BUMCode;
                                ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                                ItemUnitOfMeasure.INSERT(TRUE);
                            END;
                        END else begin
                            Error(Text002, I_Articel_No);
                        end;
                        if (Grcd_ItemImport."Base Unit of Measure" = '') then
                            Grcd_ItemImport.VALIDATE(Grcd_ItemImport."Base Unit of Measure", Gcde_BUMCode);
                        //>> Validate End
                        Grcd_ItemImport."ABC-Part" := I_ABC;
                        Grcd_ItemImport."Description 2" := I_Name2_Desc2;

                        //Control Replenishment System
                        IF ((I_BOMLines_RepSystem_BOM = '0') AND
                           (Grcd_ItemImport."Replenishment System" = Grcd_ItemImport."Replenishment System"::"Prod. Order")) THEN
                            Gbol_ReplishDiff := TRUE;
                        IF ((I_BOMLines_RepSystem_BOM <> '0') AND
                           (Grcd_ItemImport."Replenishment System" = Grcd_ItemImport."Replenishment System"::Purchase)) THEN BEGIN
                            Grcd_ProdBOM.RESET;
                            IF Grcd_ProdBOM.GET(Grcd_ItemImport."No.") THEN
                                Grcd_ItemImport."Replenishment System" := Grcd_ItemImport."Replenishment System"::"Prod. Order"
                            ELSE
                                Gbol_ReplishDiff := TRUE;
                        END;
                        IF I_BOMLines_RepSystem_BOM > '0' THEN BEGIN
                            Grcd_ItemImport."Replenishment System" := Grcd_ItemImport."Replenishment System"::"Prod. Order";
                            Grcd_ItemImport."Production BOM No." := I_Articel_No;
                        END ELSE BEGIN
                            Grcd_ItemImport."Replenishment System" := Grcd_ItemImport."Replenishment System"::Purchase;
                            Grcd_ItemImport."Production BOM No." := '';
                        END;
                        //++Harvey

                        Grcd_ItemImport.VALIDATE("Rounding Precision", RoundingPrecision);
                        Grcd_ItemImport."Global Dimension 5 Code" := BrandCode;
                        IF COPYSTR(I_Articel_No, 1, 1) = 'T' THEN
                            // Grcd_ItemImport."Global Dimension 2 Code" := 'WT'
                            Grcd_ItemImport.Validate("Global Dimension 2 Code", 'WT')
                        else
                            // Grcd_ItemImport."Global Dimension 2 Code" := 'WPM';
                            Grcd_ItemImport.Validate("Global Dimension 2 Code", 'WPM');

                        if FlushingMethod <> '' then
                            Evaluate(Grcd_ItemImport."Flushing Method", FlushingMethod)
                        else
                            Grcd_ItemImport."Flushing Method" := Grcd_ItemImport."Flushing Method"::"Pick + Backward";
                        Grcd_ItemImport."Part status" := I_SML3;
                        Grcd_ItemImport."Last Date Modified" := D;
                        Grcd_ItemImport."Costing Method" := Grcd_ItemImport."Costing Method"::Average;
                        Grcd_ItemImport."Gen. Prod. Posting Group" := Gcde_GenPostGroup;
                        Grcd_ItemImport."Inventory Posting Group" := Gcde_InvePostGroup;
                        Grcd_ItemImport.Validate("VAT Prod. Posting Group", 'VAT13');
                        Grcd_ItemImport."Include Inventory" := true;
                        Grcd_ItemImport.Critical := true;
                        Grcd_ItemImport."Posting Group" := I_SML1;
                        Grcd_ItemImport."PLM Import Flag" := TRUE;
                        Grcd_ItemImport.MODIFY;
                    END ELSE BEGIN
                        // IF (Gbol_BaseError = FALSE) and (D >= Yesterday) and (ToDay >= D) THEN BEGIN
                        IF Gbol_BaseError = FALSE THEN BEGIN
                            Gbol_NewItem := TRUE;
                            Grcd_ItemImport.INIT;
                            Grcd_ItemImport."No." := I_Articel_No;
                            Grcd_ItemImport.Description := I_Name_Desc;
                            Grcd_ItemImport.VALIDATE(Grcd_ItemImport.Description, I_Name_Desc);
                            Grcd_ItemImport."Description 2" := I_Name2_Desc2;
                            //  Grcd_ItemImport."Base Unit of Measure" := Gcde_BUMCode;
                            //<< Validate Begin
                            IF (Gcde_BUMCode <> '') THEN BEGIN
                                IF NOT ItemUnitOfMeasure.GET(I_Articel_No, Gcde_BUMCode) THEN BEGIN
                                    ItemUnitOfMeasure.INIT;
                                    ItemUnitOfMeasure."Item No." := I_Articel_No;
                                    ItemUnitOfMeasure.Code := Gcde_BUMCode;
                                    ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                                    ItemUnitOfMeasure.INSERT(TRUE);
                                END;
                            END else begin
                                Error(Text002, I_Articel_No);
                            end;
                            Grcd_ItemImport.VALIDATE(Grcd_ItemImport."Base Unit of Measure", Gcde_BUMCode);
                            //>> Validate End

                            Grcd_ItemImport."Purch. Unit of Measure" := Gcde_BUMCode;
                            Grcd_ItemImport."Sales Unit of Measure" := Gcde_BUMCode;
                            Grcd_ItemImport."Costing Method" := Grcd_ItemImport."Costing Method"::Average;
                            Grcd_ItemImport."Cost is Adjusted" := TRUE;
                            Grcd_ItemImport."Cost is Posted to G/L" := TRUE;
                            Grcd_ItemImport."Price/Profit Calculation" := Grcd_ItemImport."Price/Profit Calculation"::"Profit=Price-Cost";
                            Grcd_ItemImport."Gen. Prod. Posting Group" := Gcde_GenPostGroup;
                            Grcd_ItemImport."VAT Prod. Posting Group" := 'VAT13';
                            Grcd_ItemImport."Inventory Posting Group" := Gcde_InvePostGroup;
                            //Control Replenishment System
                            IF I_BOMLines_RepSystem_BOM > '0' THEN BEGIN
                                Grcd_ItemImport."Replenishment System" := Grcd_ItemImport."Replenishment System"::"Prod. Order";
                                Grcd_ItemImport."Production BOM No." := I_Articel_No;
                            END ELSE BEGIN
                                Grcd_ItemImport."Replenishment System" := Grcd_ItemImport."Replenishment System"::Purchase;
                                Grcd_ItemImport."Production BOM No." := '';
                            END;

                            Grcd_ItemImport."Manufacturing Policy" := Grcd_ItemImport."Manufacturing Policy"::"Make-to-Stock";
                            if FlushingMethod <> '' then
                                Evaluate(Grcd_ItemImport."Flushing Method", FlushingMethod)
                            else
                                Grcd_ItemImport."Flushing Method" := Grcd_ItemImport."Flushing Method"::"Pick + Backward";
                            Grcd_ItemImport."Reordering Policy" := Grcd_ItemImport."Reordering Policy"::"Fixed Reorder Qty.";

                            Grcd_ItemImport."ABC-Part" := I_ABC;
                            Grcd_ItemImport."PLM Import Flag" := TRUE;
                            //++Harvey
                            Grcd_ItemImport.VALIDATE("Rounding Precision", RoundingPrecision);
                            Grcd_ItemImport."Global Dimension 5 Code" := BrandCode;
                            IF COPYSTR(I_Articel_No, 1, 1) = 'T' THEN
                                Grcd_ItemImport."Global Dimension 2 Code" := 'WT'
                            else
                                Grcd_ItemImport."Global Dimension 2 Code" := 'WPM';

                            Grcd_ItemImport."Part status" := I_SML3;
                            Grcd_ItemImport."Last Date Modified" := D;
                            Grcd_ItemImport."Costing Method" := Grcd_ItemImport."Costing Method"::Average;
                            Grcd_ItemImport.Validate("VAT Prod. Posting Group", 'VAT13');
                            Grcd_ItemImport."Reordering Policy" := Grcd_ItemImport."Reordering Policy"::"Lot-for-Lot";
                            Grcd_ItemImport."Include Inventory" := true;
                            Grcd_ItemImport.Critical := true;
                            Grcd_ItemImport."Posting Group" := I_SML1;

                            if UPPERCASE(CopyStr(Grcd_ItemImport."No.", 1, 1)) = 'T' then begin
                                if UPPERCASE(Grcd_ItemImport."Posting Group") = 'ZPTI' then begin
                                    Grcd_ItemImport."Routing No." := 'TSKTAB01';
                                end;
                                if (UPPERCASE(CopyStr(Grcd_ItemImport."No.", StrLen(Grcd_ItemImport."No."), 1)) <> 'R') and (UPPERCASE(CopyStr(Grcd_ItemImport."Posting Group", 1, 4)) = 'ZMOD') then begin
                                    Grcd_ItemImport."Routing No." := 'TSKMUD02';
                                end;
                                if UPPERCASE(CopyStr(Grcd_ItemImport."Posting Group", 1, 4)) = 'HALB' then begin
                                    Grcd_ItemImport."Routing No." := 'TSKPT01';
                                end;
                                if (UPPERCASE(CopyStr(Grcd_ItemImport."No.", StrLen(Grcd_ItemImport."No."), 1)) = 'R') and (Grcd_ItemImport."Inventory Posting Group" = 'MODULE') then begin
                                    Grcd_ItemImport."Routing No." := 'REPAIR';
                                end;

                                if (UPPERCASE(Grcd_ItemImport."Routing No.") = 'REPAIR') and (UPPERCASE(CopyStr(Grcd_ItemImport."No.", StrLen(Grcd_ItemImport."No."), 1)) = 'R') and (Grcd_ItemImport."Inventory Posting Group" = 'MODULE') and (Grcd_ItemImport."Production BOM No." <> '') then begin
                                    Grcd_ItemImport."Production BOM No." := '';
                                end;

                            end;
                            Grcd_ItemImport.INSERT;
                            Grcd_ItemImport.Validate("Global Dimension 2 Code");
                            Grcd_ItemImport.Modify();
                        END;
                    END;

                    //++Harvey更新“单位”字段 m mm保留0.001 其他都为1
                    Item2.Reset();
                    Item2.SetRange("Rounding Precision", 0.001);
                    Item2.SetFilter("No.", '<>%1', '');
                    if Item2.FindFirst() then
                        repeat
                            if (UPPERCASE(Item2."Base Unit of Measure") <> 'MM') or (UPPERCASE(Item2."Base Unit of Measure") <> 'M') then begin
                                Item2."Rounding Precision" := 1;
                            end;
                        until Item2.Next() = 0;
                    //--Harvey

                    //++++++++++++++++++++++++++++
                    //Record The Different --------

                    IF Gbol_BaseError OR Gbol_BaseDiff OR Gbol_SparePartDiff OR Gbol_ReplishDiff
                       OR Gbol_NoABC OR Gbol_NewItem OR Gbol_PostingGroup THEN BEGIN
                        ErrorItemLisrFunction(I_Articel_No, I_Name_Desc, Gbol_BaseError, Gbol_BaseDiff,
                           Gbol_SparePartDiff, Gbol_ReplishDiff, Gbol_NoABC, Gbol_NewItem, Gbol_PostingGroup);
                    END;
                    //+++++++++++++++++++++++++++++
                    //CurrDataport.SKIP;
                end;

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
    var
        Item: Record Item;

    begin
        Window.OPEN('Refresh Item No.#1##################');
        //clear import flag
        // Item.Reset();
        // Item.SetRange("PLM Import Flag", true);
        // if Item.FindFirst() then
        //     repeat
        //         Window.Update(1, Item."No.");
        //         Item."PLM Import Flag" := false;
        //         Item.Modify();
        //     until Item.Next() = 0;

        Item.Reset();
        Item.SetRange("Global Dimension 2 Code", '');
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");
                IF COPYSTR(Item."No.", 1, 1) = 'T' THEN
                    // Item."Global Dimension 2 Code" := 'WT'
                    Item.Validate("Global Dimension 2 Code", 'WT')
                else
                    // Item."Global Dimension 2 Code" := 'WPM';
                    Item.Validate("Global Dimension 2 Code", 'WPM');
                Item.Modify();
            until Item.Next() = 0;

        Item.Reset();
        Item.SetRange("Gen. Prod. Posting Group", '');
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");
                if Item."Old Gen. Prod. Posting Group" <> '' then begin
                    if ProductGroupMapping.Get(Item."Old Gen. Prod. Posting Group") then
                        Item."Gen. Prod. Posting Group" := ProductGroupMapping."New Code";
                    Item.Modify();
                end;

            until Item.Next() = 0;

        Item.Reset();
        Item.SetRange("Inventory Posting Group", '');
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");

                if (Item."Inventory Posting Group" = '') and (Item."Old Inventory Posting Group" <> '') then begin
                    if InventoryGroupMapping.Get(Item."Old Inventory Posting Group") then
                        Item."Inventory Posting Group" := InventoryGroupMapping."New Code";
                end;
                Item.Modify();
            until Item.Next() = 0;

        Window.Close();

        Window.OPEN('Item No.#1##################');
    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
    end;

    procedure ErrorItemLisrFunction(P_ItemNo: Code[20]; P_Description: Text[100]; P_BaseError: Boolean; P_BaseDiff: Boolean; P_SparePartDiff: Boolean; P_ReplishDiff: Boolean; P_NoABC: Boolean; P_NewItem: Boolean; P_PostingGroup: Boolean)
    var
        Lrcd_PLMResult: Record "Item PLM To Nav Result";
        Lint_EntryNo: Integer;
    begin
        // IF NOT Lrcd_PLMResult.GET(I_Articel_No) THEN BEGIN
        Lrcd_PLMResult.RESET;
        IF Lrcd_PLMResult.FIND('+') THEN
            Lint_EntryNo := Lrcd_PLMResult."Entry No" + 1
        ELSE
            Lint_EntryNo := 1;
        Lrcd_PLMResult.INIT;
        Lrcd_PLMResult."Entry No" := Lint_EntryNo;
        Lrcd_PLMResult."No." := P_ItemNo;
        Lrcd_PLMResult.Description := P_Description;
        Lrcd_PLMResult."Description 2" := '';
        Lrcd_PLMResult."Base Unit Error" := P_BaseError;
        Lrcd_PLMResult."Base Unit Difference" := P_BaseDiff;
        Lrcd_PLMResult."Spare Part Difference" := P_SparePartDiff;
        Lrcd_PLMResult."Replishment Difference" := P_ReplishDiff;
        Lrcd_PLMResult."No ABC Parts" := P_NoABC;
        Lrcd_PLMResult."New Create Item" := P_NewItem;
        Lrcd_PLMResult."Posting Group Difference" := P_PostingGroup;
        Lrcd_PLMResult."Created Date" := TODAY;
        Lrcd_PLMResult."Created Time" := TIME;
        Lrcd_PLMResult."User ID" := USERID;
        Lrcd_PLMResult.INSERT;
    end;

    procedure ConvertDate(DateText: Text[20]): date
    var
        YearL: Integer;
        MonthL: Integer;
        DayL: Integer;
    begin
        if StrPos(DateText, '.') <> 0 then begin
            Evaluate(DayL, CopyStr(DateText, 1, 2));
            Evaluate(MonthL, CopyStr(DateText, 4, 2));
            Evaluate(YearL, CopyStr(DateText, 7, 2));
            exit(DMY2Date(DayL, MonthL, 2000 + YearL));
        end else
            if StrPos(DateText, '/') <> 0 then begin
                Evaluate(YearL, CopyStr(DateText, 1, 4));
                if StrLen(DateText) = 8 then begin
                    Evaluate(MonthL, CopyStr(DateText, 6, 1));
                    Evaluate(DayL, CopyStr(DateText, 8, 1));
                end;
                if StrLen(DateText) = 9 then begin
                    if CopyStr(DateText, 7, 1) = '/' then begin
                        Evaluate(MonthL, CopyStr(DateText, 6, 1));
                        Evaluate(DayL, CopyStr(DateText, 8, 2));
                    end else begin
                        Evaluate(MonthL, CopyStr(DateText, 6, 2));
                        Evaluate(DayL, CopyStr(DateText, 9, 1));
                    end;

                end;
                if StrLen(DateText) = 10 then begin
                    Evaluate(MonthL, CopyStr(DateText, 6, 2));
                    Evaluate(DayL, CopyStr(DateText, 9, 2));
                end;
                exit(DMY2Date(DayL, MonthL, YearL));
            end;

    end;

    procedure ConvertUOM(var UOMP: Code[10]; var RoundingP: Decimal)
    begin
        UOMP := '';
        IF (UPPERCASE(I_QuantityUnit_BUM) = 'ST') OR (UPPERCASE(I_QuantityUnit_BUM) = 'PCS') THEN begin
            UOMP := 'PCS';
            RoundingP := 1;
        end ELSE
            IF UPPERCASE(I_QuantityUnit_BUM) = 'M' THEN begin
                UOMP := 'M';
                RoundingP := 0.001;
            end ELSE
                IF UPPERCASE(I_QuantityUnit_BUM) = 'MM' THEN begin
                    UOMP := 'MM';
                    RoundingP := 0.001;
                end ELSE
                    IF UPPERCASE(I_QuantityUnit_BUM) = 'KG' THEN begin
                        UOMP := 'KG';
                        RoundingP := 1;
                    end ELSE
                        IF UPPERCASE(I_QuantityUnit_BUM) = 'G' THEN begin
                            UOMP := 'G';
                            RoundingP := 1;
                        end ELSE
                            IF UPPERCASE(I_QuantityUnit_BUM) = 'T' THEN begin
                                UOMP := 'T';
                                RoundingP := 1;
                            end ELSE
                                IF UPPERCASE(I_QuantityUnit_BUM) = 'L' THEN begin
                                    UOMP := 'L';
                                    RoundingP := 1;
                                end ELSE
                                    IF UPPERCASE(I_QuantityUnit_BUM) = 'P' THEN begin
                                        UOMP := 'P';
                                        RoundingP := 1;
                                    end ELSE
                                        IF UPPERCASE(I_QuantityUnit_BUM) = 'ML' THEN begin
                                            UOMP := 'ML';
                                            RoundingP := 1;
                                        end ELSE
                                            IF UPPERCASE(I_QuantityUnit_BUM) = 'SET' THEN begin
                                                UOMP := 'S';
                                                RoundingP := 1;
                                            end ELSE
                                                IF UPPERCASE(I_QuantityUnit_BUM) = 'M2' THEN begin
                                                    UOMP := 'M2';
                                                    RoundingP := 1;
                                                end ELSE
                                                    IF UPPERCASE(I_QuantityUnit_BUM) = 'CM2' THEN begin
                                                        UOMP := 'CM2';
                                                        RoundingP := 1;
                                                    end ELSE begin
                                                        Gbol_BaseError := TRUE;
                                                        RoundingP := 1;
                                                    end;
    end;

    var
        Window: Dialog;
        Grcd_PLMResult: Record "Item PLM To Nav Result";
        Grcd_ItemImport: Record Item;
        Grcd_ItemRefound: Record Item;
        Grcd_ItemLedgerEntry: Record "Item Ledger Entry";
        Grcd_InvPostingGroup: Record "Inventory Posting Group";
        Grcd_GenProPostingGroup: Record "Gen. Product Posting Group";
        Grcd_UnitOfMeasure: Record "Unit of Measure";
        Grcd_ProdBOM: Record "Production BOM Header";
        Gcde_FirstLetter: Code[2];
        Gcde_BUMCode: Code[20];
        Gcde_InvePostGroup: Code[30];
        Gcde_GenPostGroup: Code[30];
        Gcde_ABCPart: Code[20];
        Gcde_PartType: Code[20];
        Gcde_Country: Code[20];
        BreakLoop: Boolean;
        BreakLoop1: Boolean;
        // I_Articel_No: Code[20];
        // I_Name_Desc: Text[50];
        // I_Name2_Desc2: Text[50];
        // I_QuantityUnit_BUM: Code[10];
        // I_Sare_ServiceItemGroup: Code[10];
        // I_BOMLines_RepSystem_BOM: Code[10];
        // I_Alternative_AlternPart: Code[250];
        // I_Code_Level_State: Code[50];
        // I_SML1: Code[30];
        // I_SML2: Code[30];
        // I_SML3: Code[30];
        // I_SML4: Code[30];
        // I_Vendor: Text[100];
        // I_VendorItemNo: Text[250];
        // I_CHParts: Code[20];
        // I_Add: Text[300];
        Gbol_BaseError: Boolean;
        Gbol_BaseDiff: Boolean;
        Gbol_SparePartDiff: Boolean;
        Gbol_ReplishDiff: Boolean;
        Gbol_NoABC: Boolean;
        Gbol_NewItem: Boolean;
        Gbol_PostingGroup: Boolean;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        // I_ABC: Code[30];
        // I_CommonItemNo: Code[20];
        RoundingPrecision: Decimal;
        Text001: Label 'Last change date cannot be empty,No.:%1';
        Text002: Label 'Unit of measure cannot be empty,No.:%1';
        Yesterday: Date;
        Today: Date;
        D: Date;
        ProductGroupMapping: Record "Product Group Mapping";
        InventoryGroupMapping: Record "Inventory Group Mapping";
        Item2: Record Item;

}
