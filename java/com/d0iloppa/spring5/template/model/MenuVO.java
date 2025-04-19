package com.d0iloppa.spring5.template.model;

/**
 * @author doil
 * @date 25. 4. 20.
 */
public class MenuVO {

    Long tree_id;
    Long parent_id;
    Long bbs_id;
    String menu_name;
    Integer sort_order;
    String page_type;
    String page_path;


    public String getMenu_name() {
        return menu_name;
    }

    public void setMenu_name(String menu_name) {
        this.menu_name = menu_name;
    }

    public Long getParent_id() {
        return parent_id;
    }

    public void setParent_id(Long parent_id) {
        this.parent_id = parent_id;
    }

    public Long getTree_id() {
        return tree_id;
    }

    public void setTree_id(Long tree_id) {
        this.tree_id = tree_id;
    }

    public Long getBbs_id() {
        return bbs_id;
    }

    public void setBbs_id(Long bbs_id) {
        this.bbs_id = bbs_id;
    }

    public Integer getSort_order() {
        return sort_order;
    }

    public void setSort_order(Integer sort_order) {
        this.sort_order = sort_order;
    }

    public String getPage_type() {
        return page_type;
    }

    public void setPage_type(String page_type) {
        this.page_type = page_type;
    }

    public String getPage_path() {
        return page_path;
    }

    public void setPage_path(String page_path) {
        this.page_path = page_path;
    }
}
