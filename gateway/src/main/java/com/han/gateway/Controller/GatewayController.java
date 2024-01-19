package com.han.gateway.Controller;

import com.han.gateway.model.Car;
import com.han.gateway.payload.*;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1")
public class GatewayController {


    private final RestTemplate restTemplate;
    private final String baseUrl = "http://localhost:8080/api/v1";

    public GatewayController(RestTemplateBuilder builder) {
        this.restTemplate = builder.build();
    }

    private HttpHeaders createHeader(String xUserName) {
        HttpHeaders headers = createHeader();
        headers.set("X-User-Name", xUserName);
        return headers;
    }

    private HttpHeaders createHeader() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        return headers;
    }

    private PaymentRequest createPayment(Integer price) {
        PaymentRequest paymentRequest = new PaymentRequest();
        paymentRequest.setPaymentUid(UUID.randomUUID());
        paymentRequest.setStatus("PAID");
        paymentRequest.setPrice(price);
        return paymentRequest;
    }

    private Car buildCar(CarResponse carResponse) {

        return Car.builder()
                .id(carResponse.getId())
                .carUid(carResponse.getCarUid())
                .brand(carResponse.getBrand())
                .model(carResponse.getModel())
                .registrationNumber(carResponse.getRegistrationNumber())
                .power(carResponse.getPower())
                .price(carResponse.getPrice())
                .type(carResponse.getType())
                .availability(carResponse.getAvailability())
                .build();
    }


    
    @GetMapping(value = "/cars", produces = "application/json")
    public ResponseEntity<PaginationResponse> getCars(@RequestParam(required = false, defaultValue = "0") int page,
                                                      @RequestParam(required = false, defaultValue = "5") int size) {
        String uri = "http://localhost:8070/api/v1/cars?page={page}&size={size}";
        ResponseEntity<PaginationResponse> paginationResponse = restTemplate.getForEntity(uri, PaginationResponse.class, page, size);
        return ResponseEntity.ok(paginationResponse.getBody());
    }

    /*成功*/
    @GetMapping(value = "/cars/{carUid}", produces = "application/json")
    public CarResponse getCar(@PathVariable("carUid") UUID carUid) {
        String uri = "http://localhost:8070/api/v1/cars/{carUid}";
        return restTemplate.getForEntity(uri, CarResponse.class, carUid).getBody();
    }


    /*成功*/
    @PostMapping(value = "/payments", consumes = "application/json", produces = "application/json")
    public PaymentResponse createPayment(@RequestBody PaymentRequest paymentRequest) {
        String uri = "http://localhost:8050/api/v1/payments";
        HttpEntity<PaymentRequest> request = new HttpEntity<>(paymentRequest);
        return restTemplate.postForObject(uri, request, PaymentResponse.class);
    }


    /*成功*/
    @PutMapping(value = "/payments/{paymentUid}", consumes = "application/json", produces = "application/json")
    public PaymentResponse updatePayment(@PathVariable("paymentUid") UUID paymentUid, @RequestBody PaymentPut paymentPut) {
        String uri = "http://localhost:8050/api/v1/payments/{paymentUid}";
        HttpHeaders headers = createHeader();
        HttpEntity<PaymentPut> entity = new HttpEntity<>(paymentPut, headers);
        return restTemplate.exchange(uri, HttpMethod.PUT, entity, PaymentResponse.class, paymentUid).getBody();
    }


    /*成功*/
    @GetMapping(value = "/payments/{paymentUid}")
    public PaymentResponse getPayment(@PathVariable("paymentUid") UUID paymentUid) {
        String uri = "http://localhost:8050/api/v1/payments/{paymentUid}";
        return restTemplate.getForObject(uri, PaymentResponse.class, paymentUid);
    }

    /*成功了，但是只能根据一个用户查询，修改了扎代码，并添加了返回名字*/
    @GetMapping(value = "/rental")
    public List<RentalShortResponse> getRentals(@RequestHeader("X-User-Name") String xUserName) {
        String uri = "http://localhost:8060/api/v1/rental";
        HttpHeaders headers = createHeader(xUserName);
        HttpEntity<HttpHeaders> request = new HttpEntity<>(headers);
        RentalResponse[] rentalResponses = restTemplate.exchange(uri, HttpMethod.GET, request, RentalResponse[].class).getBody();
        List<RentalShortResponse> results = new ArrayList<>();
        assert rentalResponses != null;
        for (RentalResponse rentalResponse : rentalResponses) {
            PaymentResponse payment = restTemplate.getForObject(baseUrl + "/payments/{paymentUid}",
                    PaymentResponse.class, rentalResponse.getPaymentUid());
            assert payment != null;
            results.add(RentalShortResponse
                    .builder()
                    .rentalUid(rentalResponse.getRentalUid())
                    .dateTo(rentalResponse.getDateTo())
                    .carUid(rentalResponse.getCarUid())
                    .username(rentalResponse.getUsername())
                    .payment(PaymentInfoResponse
                            .builder()
                            .price(payment.getPrice())
                            .status(payment.getStatus())
                            .build())
                    .dateFrom(rentalResponse.getDateFrom())
                    .status(rentalResponse.getStatus())
                    .build());

            /*.builder()
                    .rentalUid(rentalResponse.getRentalUid())
                    .dateTo(rentalResponse.getDateTo())
                    .car(CarShortResponse
                            .builder()
                            .carUid(rentalResponse.getCar().getCarUid())
                            .brand(rentalResponse.getCar().getBrand())
                            .model(rentalResponse.getCar().getModel())
                            .build())
                    .payment(PaymentInfoResponse
                            .builder()
                            .price(payment.getPrice())
                            .status(payment.getStatus())
                            .build())
                    .dateFrom(rentalResponse.getDateFrom())
                    .status(rentalResponse.getStatus())
                    .build());*/
        }
        return results;
    }

    @GetMapping(value = "/rental/{rentalUid}")
    public RentalShortResponse getRental(@RequestHeader("X-User-Name") String xUserName,
                                         @PathVariable("rentalUid") UUID rentalUid) {
        RentalResponse rental = getRentalLong(xUserName, rentalUid);
        assert rental != null;
        PaymentResponse payment = restTemplate.getForObject(baseUrl + "/payments/{paymentUid}",
                PaymentResponse.class, rental.getPaymentUid());
//        Car car = rental.getCar();
        assert payment != null;
        return RentalShortResponse
                .builder()
                .rentalUid(rentalUid)
                .carUid(rental.getCarUid())
                .username(rental.getUsername())
                .dateFrom(rental.getDateFrom())
                .dateTo(rental.getDateTo())
                .status(rental.getStatus())
                .payment(PaymentInfoResponse
                        .builder()
                        .status(payment.getStatus())
                        .price(payment.getPrice())
                        .build()
                )
                .build();
    }

    private RentalResponse getRentalLong(String xUserName, UUID rentalUid) {
        String uri = "http://localhost:8060/api/v1/rental/{rentalUid}";
        HttpHeaders headers = createHeader(xUserName);
        HttpEntity<HttpHeaders> request = new HttpEntity<>(headers);
        return restTemplate
                .exchange(uri, HttpMethod.GET, request, RentalResponse.class, rentalUid).getBody();
    }


    /*成功，rental表中的paymentUid要和payment表中的paymentUid一致*/
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @DeleteMapping("/rental/{rentalUid}")
    public void cancelRental(@RequestHeader("X-User-Name") String xUserName,
                             @PathVariable("rentalUid") UUID rentalUid) {
//        HttpHeaders headers = createHeader(xUserName);
        RentalResponse rental = getRentalLong(xUserName, rentalUid);
        assert rental != null;
        PaymentResponse payment = restTemplate.getForObject(baseUrl + "/payments/{paymentUid}",
                PaymentResponse.class, rental.getPaymentUid());

        assert payment != null;
        UUID paymentUid = payment.getPaymentUid();

        HttpHeaders paymentHeaders = createHeader();

        PaymentPut paymentPut = new PaymentPut();
        paymentPut.setStatus("CANCELED");
        HttpEntity<PaymentPut> paymentRequest = new HttpEntity<>(paymentPut, paymentHeaders);

        restTemplate.exchange(baseUrl + "/payments/{paymentUid}", HttpMethod.PUT, paymentRequest, PaymentResponse.class, paymentUid);
        String uriToDelete = "http://localhost:8060/api/v1/rental/{rentalUid}";
        restTemplate.delete(uriToDelete, rentalUid);
    }

}
