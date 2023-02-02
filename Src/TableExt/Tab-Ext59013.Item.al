tableextension 59013 "TP Item" extends Item
{
    fields
    {
        //++BC190.HH-------------------------------------------------------------------------------
        //扩展描述字段（Description英文，Description 2中文, Description 3用于扩展Description）
        field(50093; "Description 3"; Text[200])
        {
            Description = 'Description 3';
        }
        //配料小车信息:用于生产配料单打印
        field(50094; "Trolley No."; Code[20])
        {
            Caption = 'Trolley No.';
            TableRelation = Trolley;
        }
        //是否启用海关监管
        field(50095; "Customs Supervision"; Boolean)
        {
            Caption = 'Customs Supervision';
        }
        //临时字段：刷新物料过账组的时候使用
        field(50096; "Old Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Old Gen. Prod. Posting Group';
        }
        field(50097; "Old Inventory Posting Group"; Code[20])
        {
            Caption = 'Old Inventory Posting Group';
        }
        //导数据时使用
        field(50099; "Part status"; Code[20])
        {
            Caption = 'Part status';
        }
        field(50100; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
        }
        //导BOM的时候使用，如果该字段为True，则导BOM的时候BOM Type=Item，并将BOM更新物料卡片上的Production BOM NO.字段
        field(50098; "Output Item"; Boolean)
        {
            Caption = 'Output Item';
        }
        //待删除
        field(59001; "Product Group"; Code[20])
        {
            Caption = 'Product Group';
            DataClassification = ToBeClassified;
            TableRelation = "TP Product Group".Code;
        }
        //Dimension Fields
        field(59002; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Global Dimension 3 Code");
            end;
        }
        field(59003; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Global Dimension 4 Code");
            end;
        }
        field(59004; "Global Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Global Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Global Dimension 5 Code");
            end;
        }
        field(59005; "Global Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Global Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Global Dimension 6 Code");
            end;
        }
        field(59006; "Global Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Global Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7), Blocked = CONST(false));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Global Dimension 7 Code");
            end;
        }
        field(59007; "Global Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Global Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8), Blocked = CONST(false));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Global Dimension 8 Code");
            end;
        }

        //--BC190.HH-------------------------------------------------------------------------------------------------

        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================
        field(50000; "ABC-Part"; Code[20])
        {
            Description = 'ABC-Part';
        }
        // field(50001; "Storage Unit"; Code[20])
        // {
        //     Description = 'KMX2009';
        // }
        field(50002; "Altern. Part #"; Code[250])
        {
            Description = 'KMX2009';
        }
        // field(50003; "Release Status"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50004; "Usage Category"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        //++待删除
        // field(50005; "Drawing #"; Code[20])
        // {
        //     Description = 'Drawing #';
        // }
        // field(50006; "Idx."; Code[20])
        // {
        //     Description = 'Idx.';
        // }
        // field(50015; "Country of Origin"; Text[30])
        // {
        //     Description = 'Country of Origin';
        // }
        // field(50016; "Cost Applying Group"; Text[30])
        // {
        //     Description = 'Cost Applying Group';
        // }
        field(50018; Remark; Text[250])
        {
            Description = 'Remark';
        }
        // field(50030; tempBuffer; Text[250])
        // {
        //     Description = 'ESG-Jacky-For Dataport Only';
        // }
        // field(50031; tempBuffer2; Text[250])
        // {
        //     Description = 'ESG-Jacky-For Dataport Only';
        // }
        // field(50032; tempBuffer3; Text[250])
        // {
        //     Description = 'ESG-Jacky-For Dataport Only';
        // }
        // field(50056; "Design Vendor No."; Text[50])
        // {
        //     Description = 'STEP1.00';
        // }
        //--

        // field(50007; "Part Type"; Code[20])
        // {
        //     Description = 'KMX2009';
        //     TableRelation = "Part Type".Code;
        // }
        // field(50008; "VP1 CHF"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50009; "VP1 EUR"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50010; "VP2 CHF"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50011; "VP2 EUR"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50012; "VP Shan"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50013; "VP ProS"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        field(50014; "Customs Class. No."; Code[20])
        {
            Description = 'Customs Class. No.';
        }
        // field(50015; "Country of Origin"; Text[30])
        // {
        //     Description = 'Country of Origin';
        // }
        // field(50016; "Cost Applying Group"; Text[30])
        // {
        //     Description = 'Cost Applying Group';
        // }
        // field(50018; Remark; Text[250])
        // {
        //     Description = 'Remark';
        // }
        // field(50019; "VP1 USD"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }
        // field(50020; "VP2 USD"; Text[30])
        // {
        //     Description = 'KMX2009';
        // }


        // field(50033; "inventory-01"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('01'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        // field(50034; "inventory-02"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                          "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('02'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        // field(50035; "inventory-13"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                          "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('13'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        // field(50036; "inventory-14"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                          "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('14'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        // field(50037; "inventory-06"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                          "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('06'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        // field(50038; "inventory-11"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                          "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('11'),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Description = 'HB1.00';
        //     FieldClass = FlowField;
        // }
        field(50040; "Last Movement"; Date)
        {
            CalcFormula = Max("Item Ledger Entry"."Posting Date" WHERE("Item No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50055; "QC Check Need"; Boolean)
        {
            Description = 'STEP1.00';
        }

        // field(50057; "Design Vendor Item No."; Text[250])
        // {
        //     Description = 'STEP1.00';
        // }
        // field(50058; "Pre-Receipt Bin Code"; Code[20])
        // {
        //     Description = 'STEP1.00';
        //     TableRelation = Bin.Code;
        // }
        // field(50059; "Drawing Status"; Option)
        // {
        //     Description = 'STEP1.00';
        //     OptionCaption = ' ,Released,In Change,In ReVersion';
        //     OptionMembers = " ",Released,"In Change","In ReVersion";
        // }
        // field(50060; "Machine Mark"; Boolean)
        // {
        //     Description = 'STEP1.00';
        // }
        // field(50061; "Inventory-Production"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('PRODUCTION')));
        //     Description = 'STEP1.00';
        //     FieldClass = FlowField;
        // }
        // field(50062; "Inventory-FG"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('FG')));
        //     Description = 'STEP1.00';
        //     Enabled = false;
        //     FieldClass = FlowField;
        // }
        // field(50063; "Inventory-D-Parts"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('D-Parts')));
        //     Description = 'STEP1.00';
        //     Enabled = false;
        //     FieldClass = FlowField;
        // }
        // field(50064; "Inventory-Spareparts"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('Spareparts')));
        //     Description = 'STEP1.00';
        //     FieldClass = FlowField;
        // }
        // field(50065; "Inventory-Service"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('Service')));
        //     Description = 'STEP1.00';
        //     Enabled = false;
        //     FieldClass = FlowField;
        // }
        // field(50066; "Inventory-TEMPSHOW"; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Location Code" = CONST('TEMPSHOW')));
        //     Description = 'STEP1.00';
        //     FieldClass = FlowField;
        // }
        // field(50070; Inventory_Old; Decimal)
        // {
        //     CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
        //                                                           "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
        //                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
        //                                                           "Location Code" = FIELD("Location Filter"),
        //                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
        //                                                           "Variant Code" = FIELD("Variant Filter"),
        //                                                           "Lot No." = FIELD("Lot No. Filter"),
        //                                                           "Serial No." = FIELD("Serial No. Filter"),
        //                                                           "Posting Date" = FILTER(.. '11/03/31')));
        //     Caption = 'Inventory_Old';
        //     DecimalPlaces = 0 : 5;
        //     Editable = false;
        //     Enabled = false;
        //     FieldClass = FlowField;
        // }
        // field(50071; "Komax CH Part#"; Code[20])
        // {
        //     Description = 'STEP1.00';
        // }
        // field(50075; "SKU Exist"; Boolean)
        // {
        //     CalcFormula = Exist("Stockkeeping Unit" WHERE("Item No." = FIELD("No."),
        //                                                    "Location Code" = CONST('SPAREPARTS')));
        //     Description = 'STEP1.00';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(50080; "Appointed Vendor No."; Code[20])
        // {
        //     TableRelation = Vendor;
        // }
        field(50081; "Purcharer Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        // field(50090; "FT Description"; Text[50])
        // {
        //     Description = 'Freddie';
        // }
        // field(50091; "FT Description 2"; Text[50])
        // {
        //     Description = 'Freddie';
        // }
        // field(50092; "Product Group Short Name"; Text[50])
        // {
        //     Description = 'Product Group Short Name';
        // }
        // field(60001; "Number of Entries"; Integer)
        // {
        //     CalcFormula = Count("Item Ledger Entry" WHERE("Item No." = FIELD("No.")));
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(60002; "PLM Import Flag"; Boolean)
        {
            Description = 'Cannot been deleted';
            Editable = false;
        }
        // field(60003; "cost(expect)"; Decimal)
        // {
        //     CalcFormula = Sum("Value Entry"."Cost Amount (Expected)" WHERE("Item No." = FIELD("No.")));
        //     FieldClass = FlowField;
        // }
        // field(60004; "cost(act)"; Decimal)
        // {
        //     CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE("Item No." = FIELD("No.")));
        //     FieldClass = FlowField;
        // }
    }
}
