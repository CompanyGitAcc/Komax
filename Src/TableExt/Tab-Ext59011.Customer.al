tableextension 59011 "TP Customer" extends Customer
{
    fields
    {
        //++BC190.HH-------------------------------------------------------------------------------
        field(50018; "Geo Location"; Text[100])
        {
            Caption = 'Geo Location';
        }
        //Dimension Fields
        field(59000; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Global Dimension 3 Code");
            end;
        }
        field(59001; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Global Dimension 4 Code");
            end;
        }
        field(59002; "Global Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Global Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Global Dimension 5 Code");
            end;
        }
        field(59003; "Global Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Global Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Global Dimension 6 Code");
            end;
        }
        field(59004; "Global Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Global Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Global Dimension 7 Code");
            end;
        }
        field(59005; "Global Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Global Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Global Dimension 8 Code");
            end;
        }
        //客户名称重复性检查
        modify(Name)
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
                Error001: Label 'Customer %1 already exists!';
            begin
                Customer.SetFilter(Name, '%1', Rec.Name);
                Customer.SetFilter("No.", '<>%1', Rec."No.");
                if Customer.FindFirst() then
                    Error(Error001, Rec.Name);
            end;
        }
        //--BC190.HH-------------------------------------------------------------------------------

        //++BC190.Deposit1.00.ALF
        field(50055; "Advance Payment %"; Decimal)
        {
            Caption = 'Advance Payment %';
        }
        modify("Credit Limit (LCY)") { trigger OnAfterValidate() begin VerifyUser end; }
        modify("Advance Payment %") { trigger OnAfterValidate() begin VerifyUser end; }
        //--BC190.Deposit1.00.ALF

        //==============================================================================
        //++NAV2009  说明：以下字段是从老系统迁移过来的字段，部分不再使用的字段已注释掉
        //==============================================================================        
        field(50006; "City (CN)"; Text[30])
        {
            Caption = 'City (CN)';
        }
        field(50007; "Short Name"; Text[20])
        {
            Caption = 'Short Name';
        }
        field(50008; "Bill-to Department"; Option)
        {
            Caption = 'Bill-to Department';
            OptionCaption = ' ,Finance Dept.,Warehouse,Purchase Dept.';
            OptionMembers = " ","Finance Dept.","Warehouse","Purchase Dept.";
        }
        field(50009; "Bill to Contact"; Text[50])
        {
            Caption = 'Bill to Contact';
            TableRelation = Contact;
            trigger OnValidate()
            var
                Cont1: Record "Contact";
                ContBusRel1: Record "Contact Business Relation";
            begin
                IF "Bill to Contact" <> '' THEN BEGIN
                    Cont1.GET("Bill to Contact");

                    ContBusRel1.SETCURRENTKEY("Link to Table", "No.");
                    ContBusRel1.SETRANGE("Link to Table", ContBusRel1."Link to Table"::Customer);
                    ContBusRel1.SETRANGE("No.", "No.");
                    ContBusRel1.FIND('-');

                    IF Cont1."Company No." <> ContBusRel1."Contact No." THEN
                        ERROR(Text003, Cont1."No.", Cont1.Name, "No.", Name);

                    IF Cont1.Type = Cont1.Type::Person THEN BEGIN
                        "Bill to Contact" := Cont1.Name;
                        "Bill to Address" := Cont1.Address;
                        "Bill to Contact Phone No." := Cont1."Phone No.";
                        "Bill to Contact Telex No." := Cont1."E-Mail";
                    END;
                END
                ELSE BEGIN
                    "Bill to Contact" := '';
                    "Bill to Address" := '';
                    "Bill to Contact Phone No." := '';
                    "Bill to Contact Telex No." := '';
                END;
            end;

            trigger OnLookup()
            var
                Cont1: Record "Contact";
                ContBusRel1: Record "Contact Business Relation";
            begin
                ContBusRel1.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel1.SETRANGE("Link to Table", ContBusRel1."Link to Table"::Customer);
                ContBusRel1.SETRANGE("No.", "No.");
                IF ContBusRel1.FINDFIRST THEN BEGIN
                    Cont1.SETRANGE("Company No.", ContBusRel1."Contact No.");
                    Cont1.SETRANGE(Cont1.Type, Cont1.Type::Person);
                END
                ELSE BEGIN
                    Cont1.SETRANGE("No.", '');
                    Cont1.SETRANGE(Cont1.Type, Cont1.Type::Person);
                END;

                IF "Bill to Contact" <> '' THEN
                    IF Cont1.GET("Bill to Contact") THEN;
                IF Page.RUNMODAL(0, Cont1) = ACTION::LookupOK THEN
                    VALIDATE("Bill to Contact", Cont1."No.");
            end;
        }
        field(50010; "Bill to Address"; Text[100])
        {
            Caption = 'Bill to Address';
        }
        field(50011; "Bill to Contact Phone No."; Text[30])
        {
            Caption = 'Bill to Contact Phone No.';
        }
        field(50012; "Bill to Contact Telex No."; Text[80])
        {
            Caption = 'Email No.';
        }
        field(50014; "Service Person"; Code[10])
        {
            Caption = 'Service Person';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50015; "Customer Type"; Option)
        {
            Caption = 'Customer Type';
            OptionCaption = 'Global Key Account,Local Key Account,Large,Mid-size,Small';
            OptionMembers = "Global Key Account","Local Key Account","Large","Mid-size","Small";
        }

        field(50017; Segementation; Option)
        {
            Caption = 'Segementation';
            OptionCaption = ' ,Aerospace,Automotive,service agent,Industry,Telecom/Datacom,Export';
            OptionMembers = " ","Aerospace","Automotive","service agent","Industry","Telecom/Datacom","Export";
        }
        field(59006; "Sales Person"; Code[10])
        {
            Caption = 'Sales Person';
            TableRelation = "Salesperson/Purchaser";
        }
        //--待删除
        // field(50019; "Sales Person"; Code[20])
        // {
        //     Caption = 'Sales Person';
        // }
        // field(50020; Industry; Option)
        // {
        //     Caption = 'Segementation';
        //     OptionCaption = ' ';
        //     OptionMembers = " ";
        // }
        //--
        modify(Contact)
        {
            trigger OnAfterValidate()
            begin
                IF xRec."Bill to Contact" = '' THEN BEGIN
                    "Bill to Contact" := Contact;
                END;
            end;
        }
        modify("Primary Contact No.")
        {
            trigger OnAfterValidate()
            var
                Cont: Record Contact;
            begin
                Contact := '';
                IF "Primary Contact No." <> '' THEN BEGIN
                    Cont.GET("Primary Contact No.");
                    IF Cont.Type = Cont.Type::Person THEN BEGIN
                        Contact := Cont.Name;
                        IF "Bill to Contact" = '' THEN
                            VALIDATE("Bill to Contact", "Primary Contact No.");
                    END;
                END;
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                IF xRec."Bill to Address" = '' THEN
                    "Bill to Address" := Address;
            end;
        }

    }
    fieldgroups
    {
        addlast(DropDown; "Name 2") { }
    }

    procedure VerifyUser()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Finance Controller");
    end;

    var
        Text003: Label 'Contact %1 %2 is not related to customer %3 %4.';

}
