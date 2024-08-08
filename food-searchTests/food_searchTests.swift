//
//  food_searchTests.swift
//  food-searchTests
//
//  Created by John Riselvato on 2024/8/8.
//

import XCTest
import Combine
@testable import food_search

final class food_searchTests: XCTestCase {

    var mockAPI: MockFoodAPI!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockFoodAPI()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        mockAPI = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchComplexSearchResultsSuccess() {
        let expectedResults = ComplexSearch(results: [SearchResult(id: 1, title: "Test Recipe", imageURL: nil)])
        mockAPI.fetchComplexSearchResultsResult = .success(expectedResults)
        
        let expectation = XCTestExpectation(description: "Fetch complex search results")
        
        mockAPI.fetchComplexSearchResults(query: "test")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure")
                }
            }, receiveValue: { results in
                XCTAssertEqual(results.results.count, 1)
                XCTAssertEqual(results.results.first?.title, "Test Recipe")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchComplexSearchResultsFailure() {
        mockAPI.fetchComplexSearchResultsResult = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Fetch complex search results failure")
        
        mockAPI.fetchComplexSearchResults(query: "test")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, URLError.Code.badServerResponse)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchRecipeResultSuccess() {
        let expectedRecipe = RecipeResult(id: 1, extendedIngredients: [], readyInMinutes: 30, summary: "Test summary", instructions: "Test instructions")
        mockAPI.fetchRecipeResultResult = .success(expectedRecipe)
        
        let expectation = XCTestExpectation(description: "Fetch recipe result")
        
        mockAPI.fetchRecipeResult(id: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure")
                }
            }, receiveValue: { recipe in
                XCTAssertEqual(recipe.id, 1)
                XCTAssertEqual(recipe.readyInMinutesFormatted, "Ready in 30 minutes")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchRecipeResultFailure() {
        mockAPI.fetchRecipeResultResult = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Fetch recipe result failure")
        
        mockAPI.fetchRecipeResult(id: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, URLError.Code.badServerResponse)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure, but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}

// Mock class for FoodAPIProtocol
class MockFoodAPI: FoodAPIProtocol {
    var fetchComplexSearchResultsResult: Result<ComplexSearch, Error>?
    var fetchRecipeResultResult: Result<RecipeResult, Error>?
    
    func fetchComplexSearchResults(query: String) -> AnyPublisher<ComplexSearch, Error> {
        if let result = fetchComplexSearchResultsResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
    }
    
    func fetchRecipeResult(id: Int) -> AnyPublisher<RecipeResult, Error> {
        if let result = fetchRecipeResultResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
    }
}
