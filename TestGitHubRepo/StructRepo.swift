//
//  StructRepo.swift
//  TestGitHubRepo
//
//  Created by Zimma on 24/10/2018.
//  Copyright © 2018 Zimma. All rights reserved.
//

struct Items: Decodable {
    let items: [Repo]
}

struct Repo: Decodable {
    let fullName: String
    let stars: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case stars = "stargazers_count"
        case url = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try conteiner.decode(String.self, forKey: .fullName)
        stars = try conteiner.decode(Int.self, forKey: .stars)
        url = try conteiner.decode(String.self, forKey: .url)
    }
}
