//
//  File.swift
//  OAuth
//
//  Created by Dheepthaa Anand on 12/12/17.
//  Copyright © 2017 Dheepthaa Anand. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIRequest
{
    func getPhotoResponse(onSuccess: @escaping () -> (), onError: @escaping (Bool,String)-> ())
    {
        
        let URL = "https://graph.facebook.com/v2.11/673007656120693/photos?access_token=EAACEdEose0cBAHQ3CgStoZBciKQSEjZALdNWMSxMJWilzZC3Wv8KqZBywrJsbegVRjcDQR0lK2iLAM39Ptej9GnAZBRAZAEEV3F1ZA0n3oOdoTC0CUPqI5ZBs7yAC94JVK3ZAPdduuOh44V2IxbihozX9RGqgAKyQ2uu78esIlAd1dDpid2ZAv0XYhxmgW5H4MEwIZD&pretty=0&limit=25&before=TkRNMk1ESXdNRFV6TVRVME5EVTNPakV6TmpRME5UWXdNekU2TXprME1EZAzVOalF3TmpRM09ETTIZD"
        Alamofire.request(URL).responseObject{(response:DataResponse<Board>) in
            if let photoResponse = response.result.value
            {
                onSuccess(photoResponse)
            }
            else
            {
                onError(true,URL)
            }
            
        }
    }
}
