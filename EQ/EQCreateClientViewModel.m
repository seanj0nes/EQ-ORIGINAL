//
//  EQCreateClientViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 5/8/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCreateClientViewModel.h"
#import "EQDataAccessLayer.h"
#import "EQDataManager.h"
#import "Provincia.h"
#import "ZonaEnvio.h"
#import "Expreso.h"
#import "Vendedor.h"
#import "Vendedor.h"
#import "Provincia.h"
#import "LineaVTA.h"
#import "TipoIvas.h"
#import "CondPag.h"
#import "NSString+Number.h"
#import "EQSession.h"
#import "Usuario.h"
#import "Cliente+extra.h"
@interface EQCreateClientViewModel()

@property(nonatomic,assign) int selectedTaxAtIndex;
@property(nonatomic,assign) int selectedProvinceAtIndex;
@property(nonatomic,assign) int selectedPaymentConditionAtIndex;
@property(nonatomic,assign) int selectedCollectorAtIndex;
@property(nonatomic,assign) int selectedSellerAtIndex;
@property(nonatomic,assign) int selectedSalesLineAtIndex;
@property(nonatomic,assign) int selectedDeliveryAreaAtIndex;
@property(nonatomic,assign) int selectedExpressAtIndex;

@end

@implementation EQCreateClientViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedTaxAtIndex = -1;
        self.selectedProvinceAtIndex = -1;
        self.selectedPaymentConditionAtIndex = -1;
        self.selectedCollectorAtIndex = -1;
        self.selectedSellerAtIndex = -1;
        self.selectedSalesLineAtIndex = -1;
        self.selectedDeliveryAreaAtIndex = -1;
        self.selectedExpressAtIndex = -1;
    }
    return self;
}

- (void)loadData{
    if (self.clientID) {
        self.client = (Cliente *)[[EQDataAccessLayer sharedInstance] objectForClass:[Cliente class] withId:self.clientID];
    }
    
}

- (void)saveClient:(NSDictionary *)clientDictionary{
    if (!self.client) {
        self.client = (Cliente *)[[EQDataAccessLayer sharedInstance] createManagedObject:NSStringFromClass([Cliente class])];
    }
    
    self.client.codigo1 = clientDictionary[@"code1"];
    self.client.codigo2 = clientDictionary[@"code2"];
    self.client.codigoPostal = clientDictionary[@"zipcode"];
    self.client.cuit = clientDictionary[@"cuit"];
    self.client.descuento1 = [clientDictionary[@"discount1"] number];
    self.client.descuento2 = [clientDictionary[@"discount2"] number];
    self.client.descuento3 = [clientDictionary[@"discount3"] number];
    self.client.descuento4 = [clientDictionary[@"discount4"] number];
    self.client.diasDePago = clientDictionary[@"collectionDays"];
    self.client.domicilio = clientDictionary[@"address"];
    self.client.domicilioDeEnvio = clientDictionary[@"deliveryAddress"];
    self.client.encCompras = clientDictionary[@"purchaseManager"];
    self.client.horario = clientDictionary[@"schedule"];
    //    self.client.latitud = clientDictionary[@"code2"];
    self.client.localidad = clientDictionary[@"locality"];
    //    self.client.longitud = clientDictionary[@"code2"];
    self.client.mail = clientDictionary[@"email"];
    self.client.nombre = clientDictionary[@"name"];
    self.client.nombreDeFantasia = clientDictionary[@"alias"];
    self.client.observaciones = clientDictionary[@"observations"];
    self.client.propietario = clientDictionary[@"owner"];
    self.client.sucursal = [clientDictionary[@"branch"] number];
    self.client.telefono = clientDictionary[@"phone"];
    self.client.web = clientDictionary[@"web"];
    self.client.activo = [NSNumber numberWithBool:YES];
    if (self.selectedCollectorAtIndex >= 0 )
        self.client.cobrador = [self obtainCollectorList][self.selectedCollectorAtIndex];
    if (self.selectedPaymentConditionAtIndex >= 0 )
        self.client.condicionDePagoID = ((CondPag *)[self obtainPaymentConditionList][self.selectedPaymentConditionAtIndex]).identifier;
    if (self.selectedExpressAtIndex >= 0 )
        self.client.expresoID = ((Expreso *)[self obtainExpressList][self.selectedExpressAtIndex]).identifier;
    if (self.selectedTaxAtIndex >= 0 )
        self.client.ivaID = ((TipoIvas *)[self obtainTaxesList][self.selectedTaxAtIndex]).identifier;
    if (self.selectedSalesLineAtIndex >= 0 )
        self.client.lineaDeVentaID = ((LineaVTA *)[self obtainSalesLineList][self.selectedSalesLineAtIndex]).identifier;
    if (self.selectedSellerAtIndex >= 0 )
        self.client.vendedor = [self obtainSellersList][self.selectedSellerAtIndex];
    else
        self.client.vendedor = [EQSession sharedInstance].user.vendedor;
    if (self.selectedProvinceAtIndex >= 0 )
        self.client.provinciaID = ((Provincia *)[self obtainProvinces][self.selectedProvinceAtIndex]).identifier;
    if (self.selectedDeliveryAreaAtIndex >= 0 )
        self.client.zonaEnvioID = ((ZonaEnvio *)[self obtainDeliveryAreaList][self.selectedDeliveryAreaAtIndex]).identifier;
    
    [[EQDataManager sharedInstance] sendClient:self.client];
}

- (NSArray *)obtainProvinces{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Provincia class]];
}

- (NSArray *)obtainDeliveryAreaList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[ZonaEnvio class]];
}

- (NSArray *)obtainExpressList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Expreso class]];
}

- (NSArray *)obtainSellersList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class]];
}

- (NSArray *)obtainCollectorList{
    return [self obtainSellersList];
}

- (NSArray *)obtainSalesLineList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[LineaVTA class]];
}

- (NSArray *)obtainPaymentConditionList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[CondPag class]];
}

- (NSArray *)obtainTaxesList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[TipoIvas class]];
}


- (void)selectedTaxAtIndex:(int)index{
    self.selectedTaxAtIndex = index;
}

- (void)selectedProvinceAtIndex:(int)index{
    self.selectedProvinceAtIndex = index;
}

- (void)selectedPaymentConditionAtIndex:(int)index{
    self.selectedPaymentConditionAtIndex = index;
}

- (void)selectedCollectorAtIndex:(int)index{
    self.selectedCollectorAtIndex = index;
}

- (void)selectedSellerAtIndex:(int)index{
    self.selectedSellerAtIndex = index;
}

- (void)selectedSalesLineAtIndex:(int)index{
    self.selectedSalesLineAtIndex = index;
}

- (void)selectedDeliveryAreaAtIndex:(int)index{
    self.selectedDeliveryAreaAtIndex = index;
}

- (void)selectedExpressAtIndex:(int)index{
    self.selectedExpressAtIndex = index;
}

- (NSString *)obtainSelectedSeller{
    return [self.client.vendedor.descripcion length] > 0 ? self.client.vendedor.descripcion : [self sellerName];
}

- (NSString *)obtainSelectedCollector{
    return [self.client.cobrador.descripcion length] > 0 ? self.client.cobrador.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedProvince{
    return [self.client.provincia.descripcion length] > 0 ? self.client.provincia.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedDeliveryArea{
    return [self.client.zonaEnvio.descripcion length] > 0 ? self.client.zonaEnvio.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedPaymentCondition{
    return [self.client.condicionDePago.descripcion length] > 0 ? self.client.condicionDePago.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedExpress{
    return [self.client.expreso.descripcion length] > 0 ? self.client.expreso.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedTaxes{
    return [self.client.iva.descripcion length] > 0 ? self.client.iva.descripcion : @SELECTION_TEXT;
}

- (NSString *)obtainSelectedSalesLine{
    return [self.client.lineaDeVenta.descripcion length] > 0 ? self.client.lineaDeVenta.descripcion : @SELECTION_TEXT;
}

@end