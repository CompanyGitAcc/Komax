page 50094 "Item Requisite Report"
{
    Caption = 'Item Requisite Report';
    UsageCategory = Lists;
    RefreshOnActivate = true;
    PageType = Worksheet;
    SourceTable = "Sales Line";
    SourceTableView = sorting("No.") order(descending);
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            //筛选条件
            group(Filters)
            {
                Caption = 'Filters';
                field(BeginDate; BeginDate)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                    end;
                }

                field(EndDate; EndDate)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if EndDate < BeginDate then
                            error('The end date cannot be later than the begin date');
                    end;
                }
                field(ItemCateCode; ItemCateCode)
                {
                    Caption = 'Item Category';
                    ApplicationArea = all;
                    TableRelation = "Item Category";
                }
                field(GenProPostingGroup; GenProPostingGroup)
                {
                    Caption = 'Gen. Pro. Posting Group';
                    ApplicationArea = all;
                    TableRelation = "Gen. Product Posting Group";
                }
                field(ItemNo; ItemNo)
                {
                    Caption = 'Item No.';
                    ApplicationArea = all;
                    // TableRelation = Item;
                    // trigger OnLookup(var Text: Text): Boolean
                    // var
                    //     ItemList: Page "Item Lookup";
                    //     Item: Record Item;
                    // begin
                    //     If ItemList.RunModal() = Action::Yes then begin
                    //         //Item:= ItemList.GetRecord();
                    //     end;
                    // end;
                }
                field(LocationCode; LocationCode)
                {
                    Caption = 'Location Code';
                    ApplicationArea = all;
                    TableRelation = Location;
                }
                field(OrderTypePara; OrderTypePara)
                {
                    Caption = 'Order Type';
                    ApplicationArea = all;
                }
            }


            repeater(General)
            {
                Editable = false;
                //报表要显示的字段
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                }
                field("Planned Shipment Date"; Rec."Planned Shipment Date")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    Caption = 'Document Type';
                    ApplicationArea = All;
                }
                field("Order Type"; Rec."Order Type 2")
                {
                    Caption = 'Order Type';
                    ApplicationArea = All;
                }
                field(OrderStatus; Rec.OrderStatus)
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field(Stock; Stock)
                {
                    Caption = 'Inventory';
                    ApplicationArea = All;
                    BlankZero = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate")
            {
                Caption = 'Calculate';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    ProdOrderComponent: Record "Prod. Order Component";
                    window: Dialog;
                begin
                    Calc();
                    Rec.SetCurrentKey("No.");
                    // CurrPage.Update();
                    if Rec.FindFirst() then;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        OrderTypePara := OrderTypePara::" ";
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        Stock := 0;
        if Rec."No." <> '' then begin
            Item.Get(Rec."No.");
            Item.CalcFields(Inventory);
            Stock := Item.Inventory;
        end;
    end;

    procedure Calc()
    var
        SalesLine: Record "Sales Line";
        ProdOrderComponent: Record "Prod. Order Component";
        window: Dialog;
        Item: Record Item;
        IncludeItem: Boolean;
        ItemCategory: Record "Item Category";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
    begin
        window.Open('#1########');
        Rec.Reset();
        if Rec.FindFirst() then
            Rec.DeleteAll();

        SalesLine.reset;
        SalesLine.SetRange("Planned Shipment Date", BeginDate, EndDate);

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        if LocationCode <> '' then
            SalesLine.SetRange("Location Code", LocationCode);
        SalesLine.SetFilter(Type, 'Item');
        if GenProPostingGroup <> '' then
            SalesLine.SetRange("Gen. Prod. Posting Group", GenProPostingGroup);
        if ItemCateCode <> '' then
            SalesLine.SetRange("Item Category Code", ItemCateCode);
        if ItemNo <> '' then
            SalesLine.SetFilter("No.", ItemNo);
        if OrderTypePara <> Rec."Order Type"::" " then
            SalesLine.SetRange("Order Type", OrderTypePara);
        if SalesLine.FindFirst() then
            repeat
                window.Update(1, SalesLine."Document No.");
                if SalesLine."Outstanding Quantity" <> 0 then begin
                    SalesLine.CalcFields("Order Type");
                    Rec.init();
                    Rec."Document Type" := SalesLine."Document Type";
                    Rec."Document No." := SalesLine."Document No.";
                    Rec."Line No." := SalesLine."Line No.";
                    Rec."No." := SalesLine."No.";
                    Rec.Description := SalesLine.Description;
                    Rec.Quantity := SalesLine.Quantity;
                    Rec."Outstanding Quantity" := SalesLine."Outstanding Quantity";
                    Rec."Planned Shipment Date" := SalesLine."Planned Shipment Date";
                    Rec.Remark := 'Sales Line';
                    Rec."Order Type 2" := SalesLine."Order Type";
                    Rec.OrderStatus2 := SalesLine.OrderStatus;
                    Rec."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
                    Rec.Insert();
                end;
            until SalesLine.Next() = 0;

        if OrderTypePara = Rec."Order Type"::" " then begin
            ProdOrderComponent.Reset();
            ProdOrderComponent.SetRange("Due Date", BeginDate, EndDate);
            if LocationCode <> '' then
                ProdOrderComponent.SetRange("Location Code", LocationCode);
            if ItemNo <> '' then
                ProdOrderComponent.SetFilter("Item No.", ItemNo);
            if ProdOrderComponent.FindFirst() then
                repeat
                    window.Update(1, ProdOrderComponent."Prod. Order No.");
                    IncludeItem := true;
                    Item.Get(ProdOrderComponent."Item No.");
                    if ItemCateCode <> '' then
                        if ItemCateCode <> Item."Item Category Code" then
                            IncludeItem := false;
                    if GenProPostingGroup <> '' then
                        if GenProPostingGroup <> Item."Gen. Prod. Posting Group" then
                            IncludeItem := false;
                    if IncludeItem then begin
                        Rec.init();
                        Rec."Document Type" := Rec."Document Type"::Order;
                        Rec."Document No." := ProdOrderComponent."Prod. Order No." + '_' + Format(ProdOrderComponent."Prod. Order Line No.");
                        Rec."Line No." := ProdOrderComponent."Line No.";

                        Rec."No." := ProdOrderComponent."Item No.";
                        Rec.Description := ProdOrderComponent.Description;
                        Rec.Quantity := ProdOrderComponent.Quantity;
                        Rec."Outstanding Quantity" := ProdOrderComponent."Remaining Quantity" - ProdOrderComponent."Qty. Picked";
                        Rec."Planned Shipment Date" := ProdOrderComponent."Due Date";
                        Rec.Remark := 'Production';
                        Rec."Order Type 2" := Rec."Order Type 2"::" ";
                        // Rec.OrderStatus2 := Rec.OrderStatus2::" ";
                        Rec."Sell-to Customer No." := '';
                        if Rec."Outstanding Quantity" <> 0 then
                            Rec.Insert();
                    end;
                until ProdOrderComponent.Next() = 0;
        end;

        Window.Close();
    end;

    var
        BeginDate: Date;
        EndDate: Date;
        GenProPostingGroup: Code[20];
        ItemCateCode: Code[20];
        ItemNo: Code[20];
        Stock: Decimal;
        LocationCode: Code[20];
        OrderTypePara: Enum "Sales Order Type";
}

