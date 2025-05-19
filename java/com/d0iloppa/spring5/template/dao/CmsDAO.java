/**
 * 
 */
package com.d0iloppa.spring5.template.dao;

import com.d0iloppa.spring5.template.model.AdminVO;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class CmsDAO extends AbstractDAO {


    public void insertMenu(List<Map<String, Object>> insertList) {
        // sqlSession.insert("CmsMapper.insertMenu", insertList);


        for (Map<String, Object> node : insertList) {

            String tempId = (String) node.get("id");
            // insert + 반환된 tree_id 저장
            sqlSession.insert("CmsMapper.insertMenuOne", node); // useGeneratedKeys로 tree_id 반환

            Long newTreeId = (Long) node.get("tree_id");

            for (Map<String, Object> target : insertList) {
                Object parent = target.get("parent");
                if (tempId.equals(parent)) {
                    target.put("parent", newTreeId);
                }
            }


        }




    }

    public void updateMenu(List<Map<String, Object>> updateList) {
        sqlSession.update("CmsMapper.updateMenu", updateList);
    }

    public void deleteMenu(List<Long> deleteList) {
        sqlSession.delete("CmsMapper.deleteMenu", deleteList);

        sqlSession.update("CmsMapper.updateOrphanageMenu", deleteList);

    }

    public Map<String, Object> getContent(Long contentId) {
        return sqlSession.selectOne("CmsMapper.getContent", contentId);
    }

}
